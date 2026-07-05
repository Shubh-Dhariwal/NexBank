<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>NexBank — Banking Management System</title>
  <link rel="stylesheet" href="css/style.css"/>
</head>
<body>
<div class="app">

  <!-- ══ SIDEBAR ══════════════════════════════════════════════════════ -->
  <aside class="sidebar">
    <div class="sidebar-logo">
      <div class="logo-icon">🏦</div>
      <h1>NexBank</h1>
      <span>MANAGEMENT SYSTEM</span>
    </div>

    <nav class="sidebar-nav">
      <div class="nav-section-label">Main</div>
      <div class="nav-item active" data-page="dashboard" onclick="navigate('dashboard')">
        <span class="nav-icon">⬛</span> Dashboard
      </div>
      <div class="nav-item" data-page="accounts" onclick="navigate('accounts')">
        <span class="nav-icon">👤</span> Accounts
      </div>
      <div class="nav-section-label" style="margin-top:12px">Operations</div>
      <div class="nav-item" data-page="transactions" onclick="navigate('transactions')">
        <span class="nav-icon">📋</span> Transactions
      </div>
      <div class="nav-item" data-page="transfer" onclick="navigate('transfer')">
        <span class="nav-icon">⇄</span> Fund Transfer
      </div>
    </nav>

    <div class="sidebar-footer">
      NexBank v1.0 &nbsp;|&nbsp; Apache Tomcat
    </div>
  </aside>

  <!-- ══ MAIN AREA ═════════════════════════════════════════════════════ -->
  <div class="main">

    <!-- Top Bar -->
    <header class="topbar">
      <h2 class="topbar-title" id="page-title">Dashboard <span>Overview</span></h2>
      <div class="topbar-actions">
        <span class="topbar-time" id="clock"></span>
        <button class="btn btn-primary btn-sm" onclick="navigate('accounts');openCreateModal()">
          + New Account
        </button>
      </div>
    </header>

    <!-- Content -->
    <main class="content">

      <!-- ───────────── DASHBOARD PAGE ───────────── -->
      <section class="page active" id="page-dashboard">
        <div class="stats-grid">
          <div class="stat-card gold">
            <span class="stat-icon">🏦</span>
            <div class="stat-label">TOTAL ACCOUNTS</div>
            <div class="stat-value" id="stat-total-acc">—</div>
            <div class="stat-sub">All registered accounts</div>
          </div>
          <div class="stat-card green">
            <span class="stat-icon">✅</span>
            <div class="stat-label">ACTIVE ACCOUNTS</div>
            <div class="stat-value" id="stat-active-acc">—</div>
            <div class="stat-sub">Currently active</div>
          </div>
          <div class="stat-card blue">
            <span class="stat-icon">💰</span>
            <div class="stat-label">TOTAL BALANCE</div>
            <div class="stat-value" id="stat-balance">—</div>
            <div class="stat-sub">Across all accounts</div>
          </div>
          <div class="stat-card red">
            <span class="stat-icon">📊</span>
            <div class="stat-label">TRANSACTIONS</div>
            <div class="stat-value" id="stat-tx-count">—</div>
            <div class="stat-sub">All time</div>
          </div>
        </div>

        <div class="grid-2">
          <div class="card">
            <div class="card-header">
              <div>
                <div class="card-title">Recent Transactions</div>
                <div class="card-sub">Latest 8 activity records</div>
              </div>
              <button class="btn btn-outline btn-sm" onclick="navigate('transactions')">View All</button>
            </div>
            <div class="table-wrap">
              <table>
                <thead>
                  <tr>
                    <th>Txn ID</th><th>Type</th><th>Account</th>
                    <th>Amount</th><th>Date</th>
                  </tr>
                </thead>
                <tbody id="dash-tx-tbody">
                  <tr><td colspan="5" class="empty">Loading…</td></tr>
                </tbody>
              </table>
            </div>
          </div>

          <div class="card">
            <div class="card-header">
              <div>
                <div class="card-title">Recent Accounts</div>
                <div class="card-sub">Latest registrations</div>
              </div>
              <button class="btn btn-outline btn-sm" onclick="navigate('accounts')">View All</button>
            </div>
            <div class="table-wrap">
              <table>
                <thead>
                  <tr><th>Account No</th><th>Holder</th><th>Balance</th><th>Status</th></tr>
                </thead>
                <tbody id="dash-acc-tbody">
                  <tr><td colspan="4" class="empty">Loading…</td></tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </section>

      <!-- ───────────── ACCOUNTS PAGE ───────────── -->
      <section class="page" id="page-accounts">
        <div class="card">
          <div class="card-header">
            <div>
              <div class="card-title">All Accounts</div>
              <div class="card-sub">Manage customer bank accounts</div>
            </div>
            <button class="btn btn-primary btn-sm" onclick="openCreateModal()">+ New Account</button>
          </div>

          <div class="filter-bar">
            <input type="text" id="acc-search" placeholder="🔍  Search by name, account no, email…"/>
            <select id="acc-type-filter">
              <option value="">All Types</option>
              <option value="SAVINGS">Savings</option>
              <option value="CURRENT">Current</option>
            </select>
            <button class="btn btn-outline btn-sm" onclick="loadAccounts()">↻ Refresh</button>
          </div>

          <div class="table-wrap">
            <table>
              <thead>
                <tr>
                  <th>Account No</th><th>Holder</th><th>Type</th>
                  <th>Balance</th><th>Status</th><th>Created</th><th>Actions</th>
                </tr>
              </thead>
              <tbody id="accounts-tbody">
                <tr><td colspan="7" class="empty">Loading accounts…</td></tr>
              </tbody>
            </table>
          </div>
        </div>
      </section>

      <!-- ───────────── TRANSACTIONS PAGE ───────────── -->
      <section class="page" id="page-transactions">
        <div class="card">
          <div class="card-header">
            <div>
              <div class="card-title">Transaction History</div>
              <div class="card-sub">All deposits, withdrawals and transfers</div>
            </div>
            <div style="display:flex;gap:10px;align-items:center">
              <select id="tx-acc-filter" style="width:220px">
                <option value="">All Accounts</option>
              </select>
              <button class="btn btn-outline btn-sm" onclick="loadTransactions()">↻ Refresh</button>
            </div>
          </div>

          <div class="table-wrap">
            <table>
              <thead>
                <tr>
                  <th>Txn ID</th><th>Type</th><th>From</th>
                  <th>To</th><th>Amount</th><th>Description</th><th>Date</th>
                </tr>
              </thead>
              <tbody id="tx-tbody">
                <tr><td colspan="7" class="empty">Loading…</td></tr>
              </tbody>
            </table>
          </div>
        </div>
      </section>

      <!-- ───────────── TRANSFER PAGE ───────────── -->
      <section class="page" id="page-transfer">
        <div style="max-width:580px;margin:0 auto">
          <div class="card">
            <div class="card-header">
              <div>
                <div class="card-title">Fund Transfer</div>
                <div class="card-sub">Transfer money between accounts instantly</div>
              </div>
            </div>

            <form id="transfer-form" onsubmit="return false">
              <div class="form-grid">
                <div class="form-group full">
                  <label>FROM ACCOUNT *</label>
                  <select id="transfer-from" onchange="updateFromBalance()">
                    <option value="">Select source account</option>
                  </select>
                  <span id="from-balance-display"
                        style="font-size:12px;color:var(--gold);margin-top:4px"></span>
                </div>

                <div class="form-group full">
                  <label>TO ACCOUNT *</label>
                  <select id="transfer-to">
                    <option value="">Select destination account</option>
                  </select>
                </div>

                <div class="form-group full">
                  <label>AMOUNT (₹) *</label>
                  <input type="number" id="transfer-amount" min="1" step="0.01"
                         placeholder="Enter amount"/>
                </div>

                <div class="form-group full">
                  <label>DESCRIPTION</label>
                  <input type="text" id="transfer-desc" placeholder="Optional note"/>
                </div>
              </div>

              <div style="margin-top:24px;display:flex;gap:12px">
                <button class="btn btn-primary" id="btn-transfer-submit"
                        onclick="submitTransfer()" style="flex:1">
                  ⇄ Transfer Funds
                </button>
                <button class="btn btn-outline"
                        onclick="document.getElementById('transfer-form').reset();
                                 document.getElementById('from-balance-display').textContent=''">
                  Clear
                </button>
              </div>
            </form>
          </div>
        </div>
      </section>

    </main><!-- /content -->
  </div><!-- /main -->
</div><!-- /app -->

<!-- ══ MODALS ════════════════════════════════════════════════════════════ -->

<!-- Create Account Modal -->
<div class="modal-overlay" id="modal-create">
  <div class="modal">
    <div class="modal-header">
      <div class="modal-title">✦ Open New Account</div>
      <button class="modal-close" onclick="closeCreateModal()">✕</button>
    </div>
    <form id="create-form" onsubmit="return false">
      <div class="form-grid">
        <div class="form-group full">
          <label>FULL NAME *</label>
          <input type="text" name="holderName" placeholder="e.g. Rahul Sharma"/>
        </div>
        <div class="form-group">
          <label>EMAIL *</label>
          <input type="email" name="email" placeholder="email@example.com"/>
        </div>
        <div class="form-group">
          <label>PHONE *</label>
          <input type="tel" name="phone" placeholder="10-digit mobile"/>
        </div>
        <div class="form-group">
          <label>ACCOUNT TYPE</label>
          <select name="accountType">
            <option value="SAVINGS">Savings</option>
            <option value="CURRENT">Current</option>
          </select>
        </div>
        <div class="form-group">
          <label>INITIAL DEPOSIT (₹)</label>
          <input type="number" name="initialDeposit" min="0" step="0.01" placeholder="0.00"/>
        </div>
      </div>
    </form>
    <div class="modal-footer">
      <button class="btn btn-outline" onclick="closeCreateModal()">Cancel</button>
      <button class="btn btn-primary" id="btn-create-submit" onclick="submitCreateAccount()">
        ✓ Create Account
      </button>
    </div>
  </div>
</div>

<!-- Edit Account Modal -->
<div class="modal-overlay" id="modal-edit">
  <div class="modal">
    <div class="modal-header">
      <div>
        <div class="modal-title">✏ Edit Account</div>
        <div style="font-size:12px;color:var(--text-muted);margin-top:4px"
             id="edit-acc-no"></div>
      </div>
      <button class="modal-close" onclick="closeEditModal()">✕</button>
    </div>
    <form id="edit-form" onsubmit="return false">
      <div class="form-grid">
        <div class="form-group full">
          <label>FULL NAME</label>
          <input type="text" name="holderName"/>
        </div>
        <div class="form-group">
          <label>EMAIL</label>
          <input type="email" name="email"/>
        </div>
        <div class="form-group">
          <label>PHONE</label>
          <input type="tel" name="phone"/>
        </div>
        <div class="form-group full">
          <label>STATUS</label>
          <select name="status">
            <option value="ACTIVE">Active</option>
            <option value="INACTIVE">Inactive</option>
            <option value="FROZEN">Frozen</option>
          </select>
        </div>
      </div>
    </form>
    <div class="modal-footer">
      <button class="btn btn-outline" onclick="closeEditModal()">Cancel</button>
      <button class="btn btn-primary" onclick="submitEditAccount()">✓ Save Changes</button>
    </div>
  </div>
</div>

<!-- Transaction Modal (Deposit / Withdraw) -->
<div class="modal-overlay" id="modal-tx">
  <div class="modal" style="max-width:420px">
    <div class="modal-header">
      <div>
        <div class="modal-title">💸 Transaction</div>
        <div style="font-size:12px;color:var(--text-muted);margin-top:4px"
             id="tx-modal-acc-no"></div>
      </div>
      <button class="modal-close" onclick="closeTxModal()">✕</button>
    </div>
    <form id="tx-form" onsubmit="return false">
      <div class="form-grid">
        <div class="form-group full">
          <label>TRANSACTION TYPE</label>
          <select name="txType">
            <option value="DEPOSIT">Deposit</option>
            <option value="WITHDRAW">Withdraw</option>
          </select>
        </div>
        <div class="form-group full">
          <label>AMOUNT (₹) *</label>
          <input type="number" name="amount" min="1" step="0.01" placeholder="Enter amount"/>
        </div>
        <div class="form-group full">
          <label>DESCRIPTION</label>
          <input type="text" name="description" placeholder="Optional note"/>
        </div>
      </div>
    </form>
    <div class="modal-footer">
      <button class="btn btn-outline" onclick="closeTxModal()">Cancel</button>
      <button class="btn btn-primary" id="btn-tx-submit" onclick="submitTransaction()">✓ Submit</button>
    </div>
  </div>
</div>

<!-- Toast Container -->
<div id="toast-container"></div>

<script src="js/main.js"></script>
<%-- tx-acc-filter is updated by updateTxFilter() inside main.js --%>
</body>
</html>
