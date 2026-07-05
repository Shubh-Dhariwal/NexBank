package com.banking.util;

import com.banking.model.Account;
import com.banking.model.Transaction;

import java.time.LocalDateTime;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.stream.Collectors;

/**
 * In-memory data store — no external DB needed.
 * Singleton. Pre-seeded with demo accounts.
 */
public class DataStore {

    private static DataStore instance;

    private final Map<String, Account>     accounts     = new ConcurrentHashMap<>();
    private final List<Transaction>        transactions = Collections.synchronizedList(new ArrayList<>());
    private final AtomicInteger            txCounter    = new AtomicInteger(1000);
    private final AtomicInteger            acCounter    = new AtomicInteger(1);

    private DataStore() { seed(); }

    public static synchronized DataStore getInstance() {
        if (instance == null) instance = new DataStore();
        return instance;
    }

    // ── Account Operations ──────────────────────────────────────────────────

    public List<Account> getAllAccounts() {
        return new ArrayList<>(accounts.values());
    }

    public Account getAccount(String accNo) {
        return accounts.get(accNo);
    }

    public Account createAccount(String holderName, String email,
                                  String phone, String accountType, double initialDeposit) {
        String accNo = generateAccountNumber();
        Account a = new Account(accNo, holderName, email, phone, accountType, initialDeposit);
        a.setId(acCounter.getAndIncrement());
        accounts.put(accNo, a);

        if (initialDeposit > 0) {
            recordTx(new Transaction(
                newTxId(), accNo, accNo, "DEPOSIT",
                initialDeposit, 0, initialDeposit, "Initial deposit"
            ));
        }
        return a;
    }

    public boolean updateAccount(String accNo, String holderName,
                                  String email, String phone, String status) {
        Account a = accounts.get(accNo);
        if (a == null) return false;
        a.setHolderName(holderName);
        a.setEmail(email);
        a.setPhone(phone);
        a.setStatus(status);
        return true;
    }

    public boolean deleteAccount(String accNo) {
        return accounts.remove(accNo) != null;
    }

    // ── Transaction Operations ───────────────────────────────────────────────

    public boolean deposit(String accNo, double amount, String desc) {
        Account a = accounts.get(accNo);
        if (a == null || !"ACTIVE".equals(a.getStatus()) || amount <= 0) return false;
        double before = a.getBalance();
        a.setBalance(before + amount);
        recordTx(new Transaction(newTxId(), accNo, accNo, "DEPOSIT",
                amount, before, a.getBalance(), desc.isEmpty() ? "Deposit" : desc));
        return true;
    }

    public boolean withdraw(String accNo, double amount, String desc) {
        Account a = accounts.get(accNo);
        if (a == null || !"ACTIVE".equals(a.getStatus()) || amount <= 0) return false;
        if (a.getBalance() < amount) return false;
        double before = a.getBalance();
        a.setBalance(before - amount);
        recordTx(new Transaction(newTxId(), accNo, accNo, "WITHDRAW",
                amount, before, a.getBalance(), desc.isEmpty() ? "Withdrawal" : desc));
        return true;
    }

    public boolean transfer(String fromAccNo, String toAccNo, double amount, String desc) {
        Account from = accounts.get(fromAccNo);
        Account to   = accounts.get(toAccNo);
        if (from == null || to == null) return false;
        if (!"ACTIVE".equals(from.getStatus()) || !"ACTIVE".equals(to.getStatus())) return false;
        if (from.getBalance() < amount || amount <= 0) return false;

        double fromBefore = from.getBalance();
        double toBefore   = to.getBalance();
        from.setBalance(fromBefore - amount);
        to.setBalance(toBefore + amount);

        String note = desc.isEmpty() ? "Transfer" : desc;
        recordTx(new Transaction(newTxId(), fromAccNo, toAccNo, "TRANSFER",
                amount, fromBefore, from.getBalance(), note + " (sent)"));
        recordTx(new Transaction(newTxId(), fromAccNo, toAccNo, "TRANSFER",
                amount, toBefore, to.getBalance(), note + " (received)"));
        return true;
    }

    public List<Transaction> getTransactions(String accNo) {
        if (accNo == null || accNo.isEmpty()) return new ArrayList<>(transactions);
        return transactions.stream()
                .filter(t -> accNo.equals(t.getFromAccount()) || accNo.equals(t.getToAccount()))
                .collect(Collectors.toList());
    }

    public List<Transaction> getRecentTransactions(int n) {
        List<Transaction> all = new ArrayList<>(transactions);
        Collections.reverse(all);
        return all.stream().limit(n).collect(Collectors.toList());
    }

    // ── Stats ────────────────────────────────────────────────────────────────

    public double getTotalDeposits() {
        return transactions.stream()
                .filter(t -> "DEPOSIT".equals(t.getType()))
                .mapToDouble(Transaction::getAmount).sum();
    }

    public double getTotalBalance() {
        return accounts.values().stream().mapToDouble(Account::getBalance).sum();
    }

    public long getActiveAccountCount() {
        return accounts.values().stream().filter(a -> "ACTIVE".equals(a.getStatus())).count();
    }

    // ── Helpers ──────────────────────────────────────────────────────────────

    private void recordTx(Transaction t) {
        t.setId(txCounter.incrementAndGet());
        transactions.add(t);
    }

    private String newTxId() {
        return "TXN" + System.currentTimeMillis() + txCounter.incrementAndGet();
    }

    private String generateAccountNumber() {
        return "ACC" + String.format("%08d", new Random().nextInt(99999999));
    }

    // ── Seed Data ─────────────────────────────────────────────────────────────

    private void seed() {

        Account a1 = new Account("ACC00000001", "Rahul Sharma", "rahul@email.com", "9876543210", "SAVINGS", 150000);
        a1.setId(1); a1.setCreatedAt(LocalDateTime.now().minusDays(120));
        accounts.put("ACC00000001", a1);

        Account a2 = new Account("ACC00000002", "Priya Patel", "priya@email.com", "9876543211", "CURRENT", 320000);
        a2.setId(2); a2.setCreatedAt(LocalDateTime.now().minusDays(90));
        accounts.put("ACC00000002", a2);

        Account a3 = new Account("ACC00000003", "Amit Kumar", "amit@email.com", "9876543212", "SAVINGS", 75000);
        a3.setId(3); a3.setCreatedAt(LocalDateTime.now().minusDays(60));
        accounts.put("ACC00000003", a3);

        Account a4 = new Account("ACC00000004", "Sneha Gupta", "sneha@email.com", "9876543213", "SAVINGS", 48000);
        a4.setId(4); a4.setStatus("FROZEN"); a4.setCreatedAt(LocalDateTime.now().minusDays(30));
        accounts.put("ACC00000004", a4);

        acCounter.set(5);

        recordTx(new Transaction("TXN1001", "ACC00000001", "ACC00000001", "DEPOSIT",   150000, 0, 150000, "Initial deposit"));
        recordTx(new Transaction("TXN1002", "ACC00000002", "ACC00000002", "DEPOSIT",   320000, 0, 320000, "Initial deposit"));
        recordTx(new Transaction("TXN1003", "ACC00000003", "ACC00000003", "DEPOSIT",   75000,  0, 75000,  "Initial deposit"));
        recordTx(new Transaction("TXN1004", "ACC00000001", "ACC00000002", "TRANSFER",  25000,  150000, 125000, "Payment (sent)"));
        recordTx(new Transaction("TXN1005", "ACC00000001", "ACC00000002", "TRANSFER",  25000,  320000, 345000, "Payment (received)"));
        recordTx(new Transaction("TXN1006", "ACC00000003", "ACC00000003", "WITHDRAW",  5000,   75000, 70000,  "ATM withdrawal"));
        recordTx(new Transaction("TXN1007", "ACC00000001", "ACC00000001", "DEPOSIT",   30000,  125000, 155000, "Salary credit"));
    }
}
