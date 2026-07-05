package com.banking.util;

import com.banking.model.Account;
import com.banking.model.Transaction;

import java.time.format.DateTimeFormatter;
import java.util.List;

public class JsonUtil {

    private static final DateTimeFormatter FMT = DateTimeFormatter.ofPattern("dd MMM yyyy, HH:mm");

    public static String accountToJson(Account a) {
        if (a == null) return "null";
        return String.format(
            "{\"id\":%d,\"accountNumber\":\"%s\",\"holderName\":\"%s\"," +
            "\"email\":\"%s\",\"phone\":\"%s\",\"accountType\":\"%s\"," +
            "\"balance\":%.2f,\"status\":\"%s\",\"createdAt\":\"%s\"}",
            a.getId(), esc(a.getAccountNumber()), esc(a.getHolderName()),
            esc(a.getEmail()), esc(a.getPhone()), esc(a.getAccountType()),
            a.getBalance(), esc(a.getStatus()),
            a.getCreatedAt() != null ? a.getCreatedAt().format(FMT) : ""
        );
    }

    public static String accountsToJson(List<Account> list) {
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < list.size(); i++) {
            if (i > 0) sb.append(",");
            sb.append(accountToJson(list.get(i)));
        }
        sb.append("]");
        return sb.toString();
    }

    public static String transactionToJson(Transaction t) {
        if (t == null) return "null";
        return String.format(
            "{\"id\":%d,\"transactionId\":\"%s\",\"fromAccount\":\"%s\"," +
            "\"toAccount\":\"%s\",\"type\":\"%s\",\"amount\":%.2f," +
            "\"balanceBefore\":%.2f,\"balanceAfter\":%.2f," +
            "\"description\":\"%s\",\"status\":\"%s\",\"createdAt\":\"%s\"}",
            t.getId(), esc(t.getTransactionId()), esc(t.getFromAccount()),
            esc(t.getToAccount()), esc(t.getType()), t.getAmount(),
            t.getBalanceBefore(), t.getBalanceAfter(),
            esc(t.getDescription()), esc(t.getStatus()),
            t.getCreatedAt() != null ? t.getCreatedAt().format(FMT) : ""
        );
    }

    public static String transactionsToJson(List<Transaction> list) {
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < list.size(); i++) {
            if (i > 0) sb.append(",");
            sb.append(transactionToJson(list.get(i)));
        }
        sb.append("]");
        return sb.toString();
    }

    public static String success(String message) {
        return "{\"success\":true,\"message\":\"" + esc(message) + "\"}";
    }

    public static String error(String message) {
        return "{\"success\":false,\"message\":\"" + esc(message) + "\"}";
    }

    private static String esc(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"")
                .replace("\n", "\\n").replace("\r", "\\r");
    }
}
