package com.banking.servlet;

import com.banking.model.Account;
import com.banking.util.DataStore;
import com.banking.util.JsonUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/api/accounts/*")
public class AccountServlet extends HttpServlet {

    private final DataStore store = DataStore.getInstance();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        setJson(res);
        PrintWriter out = res.getWriter();

        String pathInfo = req.getPathInfo(); // e.g. /ACC00000001 or null

        if (pathInfo == null || pathInfo.equals("/")) {
            // GET /api/accounts  → list all
            List<Account> all = store.getAllAccounts();
            out.print(JsonUtil.accountsToJson(all));
        } else {
            // GET /api/accounts/{accNo}
            String accNo = pathInfo.substring(1);
            Account a = store.getAccount(accNo);
            if (a == null) { res.setStatus(404); out.print(JsonUtil.error("Account not found")); }
            else out.print(JsonUtil.accountToJson(a));
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        setJson(res);
        PrintWriter out = res.getWriter();

        String holderName   = param(req, "holderName");
        String email        = param(req, "email");
        String phone        = param(req, "phone");
        String accountType  = param(req, "accountType");
        String depositStr   = param(req, "initialDeposit");

        if (holderName.isEmpty() || email.isEmpty() || phone.isEmpty()) {
            res.setStatus(400);
            out.print(JsonUtil.error("Name, email and phone are required"));
            return;
        }

        double deposit = 0;
        try { deposit = Double.parseDouble(depositStr); } catch (Exception e) { deposit = 0; }

        Account created = store.createAccount(holderName, email, phone, accountType, deposit);
        out.print("{\"success\":true,\"message\":\"Account created successfully\",\"account\":" +
                  JsonUtil.accountToJson(created) + "}");
    }

    @Override
    protected void doPut(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        setJson(res);
        PrintWriter out = res.getWriter();

        String pathInfo = req.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            res.setStatus(400); out.print(JsonUtil.error("Account number required")); return;
        }
        String accNo = pathInfo.substring(1);

        String holderName = param(req, "holderName");
        String email      = param(req, "email");
        String phone      = param(req, "phone");
        String status     = param(req, "status");

        boolean ok = store.updateAccount(accNo, holderName, email, phone, status);
        if (!ok) { res.setStatus(404); out.print(JsonUtil.error("Account not found")); }
        else out.print(JsonUtil.success("Account updated successfully"));
    }

    @Override
    protected void doDelete(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        setJson(res);
        PrintWriter out = res.getWriter();

        String pathInfo = req.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            res.setStatus(400); out.print(JsonUtil.error("Account number required")); return;
        }
        String accNo = pathInfo.substring(1);
        boolean ok = store.deleteAccount(accNo);
        if (!ok) { res.setStatus(404); out.print(JsonUtil.error("Account not found")); }
        else out.print(JsonUtil.success("Account deleted"));
    }

    // ── helpers ──────────────────────────────────────────────────────────────

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
