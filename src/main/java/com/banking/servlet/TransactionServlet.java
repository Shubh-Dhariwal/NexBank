package com.banking.servlet;

import com.banking.util.DataStore;
import com.banking.util.JsonUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/api/transactions/*")
public class TransactionServlet extends HttpServlet {

    private final DataStore store = DataStore.getInstance();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        setJson(res);
        PrintWriter out = res.getWriter();

        String pathInfo = req.getPathInfo(); // /ACC... or null
        String accNo = (pathInfo != null && pathInfo.length() > 1) ? pathInfo.substring(1) : "";
        out.print(JsonUtil.transactionsToJson(store.getTransactions(accNo)));
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        setJson(res);
        PrintWriter out = res.getWriter();

        String type    = param(req, "type");          // DEPOSIT | WITHDRAW | TRANSFER
        String accNo   = param(req, "accountNumber");
        String toAccNo = param(req, "toAccountNumber");
        String amtStr  = param(req, "amount");
        String desc    = param(req, "description");

        double amount;
        try { amount = Double.parseDouble(amtStr); }
        catch (Exception e) { res.setStatus(400); out.print(JsonUtil.error("Invalid amount")); return; }

        boolean ok;
        switch (type.toUpperCase()) {
            case "DEPOSIT":
                ok = store.deposit(accNo, amount, desc);
                break;
            case "WITHDRAW":
                ok = store.withdraw(accNo, amount, desc);
                break;
            case "TRANSFER":
                ok = store.transfer(accNo, toAccNo, amount, desc);
                break;
            default:
                res.setStatus(400);
                out.print(JsonUtil.error("Unknown transaction type: " + type));
                return;
        }

        if (!ok) {
            res.setStatus(400);
            out.print(JsonUtil.error("Transaction failed – check account status or balance"));
        } else {
            out.print(JsonUtil.success(type + " of ₹" + String.format("%.2f", amount) + " successful"));
        }
    }

    private void setJson(HttpServletResponse res) {
        res.setContentType("application/json");
        res.setCharacterEncoding("UTF-8");
        res.setHeader("Access-Control-Allow-Origin", "*");
    }

    private String param(HttpServletRequest req, String name) {
        String v = req.getParameter(name);
        return v == null ? "" : v.trim();
    }
}
