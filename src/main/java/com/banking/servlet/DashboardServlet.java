package com.banking.servlet;

import com.banking.util.DataStore;
import com.banking.util.JsonUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/api/dashboard")
public class DashboardServlet extends HttpServlet {

    private final DataStore store = DataStore.getInstance();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        res.setContentType("application/json");
        res.setCharacterEncoding("UTF-8");
        res.setHeader("Access-Control-Allow-Origin", "*");

        PrintWriter out = res.getWriter();

        long totalAccounts  = store.getAllAccounts().size();
        long activeAccounts = store.getActiveAccountCount();
        double totalBalance  = store.getTotalBalance();
        double totalDeposits = store.getTotalDeposits();
        long totalTx         = store.getTransactions("").size();

        String recentTx = JsonUtil.transactionsToJson(store.getRecentTransactions(10));
        String recentAcc = JsonUtil.accountsToJson(
            store.getAllAccounts().stream()
                 .sorted((a, b) -> b.getId() - a.getId())
                 .limit(5)
                 .collect(java.util.stream.Collectors.toList())
        );

        out.printf("{\"totalAccounts\":%d,\"activeAccounts\":%d," +
                   "\"totalBalance\":%.2f,\"totalDeposits\":%.2f," +
                   "\"totalTransactions\":%d," +
                   "\"recentTransactions\":%s," +
                   "\"recentAccounts\":%s}",
                totalAccounts, activeAccounts,
                totalBalance, totalDeposits,
                totalTx, recentTx, recentAcc);
    }
}
