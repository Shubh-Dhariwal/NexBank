package com.banking.model;

import java.time.LocalDateTime;

public class Account {
    private int id;
    private String accountNumber;
    private String holderName;
    private String email;
    private String phone;
    private String accountType; // SAVINGS, CURRENT
    private double balance;
    private String status; // ACTIVE, INACTIVE, FROZEN
    private LocalDateTime createdAt;

    public Account() {}

    public Account(String accountNumber, String holderName, String email,
                   String phone, String accountType, double balance) {
        this.accountNumber = accountNumber;
        this.holderName = holderName;
        this.email = email;
        this.phone = phone;
        this.accountType = accountType;
        this.balance = balance;
        this.status = "ACTIVE";
        this.createdAt = LocalDateTime.now();
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getAccountNumber() { return accountNumber; }
    public void setAccountNumber(String accountNumber) { this.accountNumber = accountNumber; }

    public String getHolderName() { return holderName; }
    public void setHolderName(String holderName) { this.holderName = holderName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getAccountType() { return accountType; }
    public void setAccountType(String accountType) { this.accountType = accountType; }

    public double getBalance() { return balance; }
    public void setBalance(double balance) { this.balance = balance; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
