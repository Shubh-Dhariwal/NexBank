package com.banking.model;

import java.time.LocalDateTime;

public class Transaction {
    private int id;
    private String transactionId;
    private String fromAccount;
    private String toAccount;
    private String type; // DEPOSIT, WITHDRAW, TRANSFER
    private double amount;
    private double balanceBefore;
    private double balanceAfter;
    private String description;
    private String status; // SUCCESS, FAILED
    private LocalDateTime createdAt;

    public Transaction() {}

    public Transaction(String transactionId, String fromAccount, String toAccount,
                       String type, double amount, double balanceBefore,
                       double balanceAfter, String description) {
        this.transactionId = transactionId;
        this.fromAccount = fromAccount;
        this.toAccount = toAccount;
        this.type = type;
        this.amount = amount;
        this.balanceBefore = balanceBefore;
        this.balanceAfter = balanceAfter;
        this.description = description;
        this.status = "SUCCESS";
        this.createdAt = LocalDateTime.now();
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTransactionId() { return transactionId; }
    public void setTransactionId(String transactionId) { this.transactionId = transactionId; }

    public String getFromAccount() { return fromAccount; }
    public void setFromAccount(String fromAccount) { this.fromAccount = fromAccount; }

    public String getToAccount() { return toAccount; }
    public void setToAccount(String toAccount) { this.toAccount = toAccount; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }

    public double getBalanceBefore() { return balanceBefore; }
    public void setBalanceBefore(double balanceBefore) { this.balanceBefore = balanceBefore; }

    public double getBalanceAfter() { return balanceAfter; }
    public void setBalanceAfter(double balanceAfter) { this.balanceAfter = balanceAfter; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
