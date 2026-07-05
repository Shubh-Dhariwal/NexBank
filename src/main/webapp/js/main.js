/* ══════════════════════════════════════════════════════════
   NexBank — Main JS (AJAX + UI)
   ══════════════════════════════════════════════════════════ */

const API = {
  ACCOUNTS:    'api/accounts',
  TRANSACTIONS:'api/transactions',
  DASHBOARD:   'api/dashboard'
};

// ── AJAX Helper ──────────────────────────────────────────────────────────────

function ajax({ method = 'GET', url, data = null, onSuccess, onError }) {
  const xhr = new XMLHttpRequest();
  xhr.open(method, url, true);
  xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest');

  if (data && method !== 'GET') {
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
  }

  xhr.onreadystatechange = function () {
    if (xhr.readyState !== 4) return;
    try {
      const res = JSON.parse(xhr.responseText);
      if (xhr.status >= 200 && xhr.status < 300) {
        onSuccess && onSuccess(res);
      } else {
        onError && onError(res);
      }
    } catch (e) {
      onError && onError({ message: 'Server error' });
    }
  };

  xhr.onerror = () => onError && onError({ message: 'Network error' });
  xhr.send(data ? encodeParams(data) : null);
}

function encodeParams(obj) {
  return Object.entries(obj)
    .map(([k, v]) => encodeURIComponent(k) + '=' + encodeURIComponent(v))
    .join('&');
}

// ── Navigation ────────────────────────────────────────────────────────────────

function navigate(pageId) {
  document.querySelectorAll('.page').forEach(p => p.classList.remove('active'));
  document.querySelectorAll('.nav-item').forEach(n => n.classList.remove('active'));

  const page = document.getElementById('page-' + pageId);
  const nav  = document.querySelector('[data-page="' + pageId + '"]');
  if (page) page.classList.add('active');
  if (nav)  nav.classList.add('active');

  // Update topbar title
  const titles = {
    dashboard:    'Dashboard <span>Overview</span>',
    accounts:     'Account <span>Management</span>',
    transactions: 'Transaction <span>History</span>',
    transfer:     'Fund <span>Transfer</span>'
  };
  document.getElementById('page-title').innerHTML = titles[pageId] || pageId;

  // Load data
  if (pageId === 'dashboard')    loadDashboard();
  if (pageId === 'accounts')     loadAccounts();
  if (pageId === 'transactions') loadTransactions();
  if (pageId === 'transfer')     populateTransferDropdowns();
}

// ── Clock ─────────────────────────────────────────────────────────────────────

function startClock() {
  function tick() {
    const now = new Date();
    document.getElementById('clock').textContent =
      now.toLocaleTimeString('en-IN', { hour: '2-digit', minute: '2-digit', second: '2-digit' });
  }
  tick(); setInterval(tick, 1000);
}

// ── Toast ─────────────────────────────────────────────────────────────────────

function toast(msg, type = 'success') {
  const icons = { success: '✓', error: '✕', info: 'ℹ' };
  const t = document.createElement('div');
  t.className = `toast ${type}`;
  t.innerHTML = `<span style="font-size:16px">${icons[type]||'•'}</span> ${msg}`;
  document.getElementById('toast-container').appendChild(t);
  setTimeout(() => t.style.opacity = '0', 2800);
  setTimeout(() => t.remove(), 3200);
}

// ── Dashboard ─────────────────────────────────────────────────────────────────

function loadDashboard() {
  ajax({
    url: API.DASHBOARD,
    onSuccess(data) {
      document.getElementById('stat-total-acc').textContent  = data.totalAccounts;
      document.getElementById('stat-active-acc').textContent = data.activeAccounts;
      document.getElementById('stat-balance').textContent    = formatINR(data.totalBalance);
      document.getElementById('stat-tx-count').textContent   = data.totalTransactions;

      renderDashboardTxTable(data.recentTransactions);
      renderDashboardAccTable(data.recentAccounts);
    },
    onError() { toast('Failed to load dashboard', 'error'); }
  });
}

function renderDashboardTxTable(txList) {
  const tbody = document.getElementById('dash-tx-tbody');
  if (!txList || txList.length === 0) {
    tbody.innerHTML = '<tr><td colspan="5" class="empty">No transactions yet</td></tr>';
    return;
  }
  tbody.innerHTML = txList.slice(0, 8).map(t => `
    <tr>
      <td class="acc-number">${t.transactionId.substring(0,12)}</td>
      <td><span class="badge badge-${t.type.toLowerCase()}">${t.type}</span></td>
      <td class="acc-number">${t.fromAccount}</td>
      <td class="${t.type==='WITHDRAW'?'amount-neg':'amount-pos'}">${formatINR(t.amount)}</td>
      <td style="color:var(--text-muted);font-size:12px">${t.createdAt}</td>
    </tr>
  `).join('');
}

function renderDashboardAccTable(accList) {
  const tbody = document.getElementById('dash-acc-tbody');
  if (!accList || accList.length === 0) {
    tbody.innerHTML = '<tr><td colspan="4" class="empty">No accounts</td></tr>';
    return;
  }
  tbody.innerHTML = accList.map(a => `
    <tr>
      <td class="acc-number">${a.accountNumber}</td>
      <td>${a.holderName}</td>
      <td class="amount-pos">${formatINR(a.balance)}</td>
      <td><span class="badge badge-${a.status.toLowerCase()}">${a.status}</span></td>
    </tr>
  `).join('');
}

// ── Accounts ──────────────────────────────────────────────────────────────────

let allAccounts = [];

function loadAccounts(filter = '', typeFilter = '') {
  ajax({
    url: API.ACCOUNTS,
    onSuccess(data) {
      allAccounts = data;
      renderAccountsTable(data, filter, typeFilter);
      populateTransferDropdowns();
      updateTxFilter();
    },
    onError() { toast('Failed to load accounts', 'error'); }
  });
}

function updateTxFilter() {
  const sel = document.getElementById('tx-acc-filter');
  if (!sel || !allAccounts) return;
  const current = sel.value;
  let opts = '<option value="">All Accounts</option>';
  allAccounts.forEach(function(a) {
    opts += '<option value="' + a.accountNumber + '"' +
            (a.accountNumber === current ? ' selected' : '') + '>' +
            a.accountNumber + ' — ' + a.holderName +
            '</option>';
  });
  sel.innerHTML = opts;
}

function renderAccountsTable(data, filter = '', typeFilter = '') {
  const tbody = document.getElementById('accounts-tbody');
  let list = data;

  if (filter) {
    const q = filter.toLowerCase();
    list = list.filter(a =>
      a.holderName.toLowerCase().includes(q) ||
      a.accountNumber.toLowerCase().includes(q) ||
      a.email.toLowerCase().includes(q)
    );
  }
  if (typeFilter) list = list.filter(a => a.accountType === typeFilter);

  if (list.length === 0) {
    tbody.innerHTML = `<tr><td colspan="7">
      <div class="empty"><div class="empty-icon">🏦</div>No accounts found</div>
    </td></tr>`;
    return;
  }

  tbody.innerHTML = list.map(a => `
    <tr>
      <td class="acc-number">${a.accountNumber}</td>
      <td><strong>${a.holderName}</strong><br>
          <span style="font-size:11px;color:var(--text-muted)">${a.email}</span></td>
      <td><span class="badge badge-${a.accountType.toLowerCase()}">${a.accountType}</span></td>
      <td class="amount-pos">${formatINR(a.balance)}</td>
      <td><span class="badge badge-${a.status.toLowerCase()}">${a.status}</span></td>
      <td style="color:var(--text-muted);font-size:12px">${a.createdAt}</td>
      <td>
        <div style="display:flex;gap:6px">
          <button class="btn btn-outline btn-sm" onclick="openEditModal('${a.accountNumber}')">✏ Edit</button>
          <button class="btn btn-outline btn-sm" onclick="openTxModal('${a.accountNumber}')">💸 Txn</button>
          <button class="btn btn-danger btn-sm" onclick="deleteAccount('${a.accountNumber}')">🗑</button>
        </div>
      </td>
    </tr>
  `).join('');
}

// ── Create Account Modal ──────────────────────────────────────────────────────

function openCreateModal() {
  document.getElementById('create-form').reset();
  document.getElementById('modal-create').classList.add('open');
}
function closeCreateModal() {
  document.getElementById('modal-create').classList.remove('open');
}

function submitCreateAccount() {
  const f = document.getElementById('create-form');
  const data = {
    holderName:     f.holderName.value.trim(),
    email:          f.email.value.trim(),
    phone:          f.phone.value.trim(),
    accountType:    f.accountType.value,
    initialDeposit: f.initialDeposit.value || '0'
  };

  if (!data.holderName || !data.email || !data.phone) {
    toast('Please fill all required fields', 'error'); return;
  }

  const btn = document.getElementById('btn-create-submit');
  btn.disabled = true;
  btn.innerHTML = '<span class="spinner"></span> Creating…';

  ajax({
    method: 'POST', url: API.ACCOUNTS, data,
    onSuccess(res) {
      toast('Account ' + res.account.accountNumber + ' created!', 'success');
      closeCreateModal();
      loadAccounts();
      btn.disabled = false; btn.innerHTML = '✓ Create Account';
    },
    onError(res) {
      toast(res.message || 'Failed to create account', 'error');
      btn.disabled = false; btn.innerHTML = '✓ Create Account';
    }
  });
}

// ── Edit Account Modal ────────────────────────────────────────────────────────

let editingAccNo = null;

function openEditModal(accNo) {
  const acc = allAccounts.find(a => a.accountNumber === accNo);
  if (!acc) { toast('Account not found', 'error'); return; }
  editingAccNo = accNo;

  const f = document.getElementById('edit-form');
  f.holderName.value = acc.holderName;
  f.email.value      = acc.email;
  f.phone.value      = acc.phone;
  f.status.value     = acc.status;

  document.getElementById('edit-acc-no').textContent = accNo;
  document.getElementById('modal-edit').classList.add('open');
}
function closeEditModal() {
  document.getElementById('modal-edit').classList.remove('open');
  editingAccNo = null;
}

function submitEditAccount() {
  if (!editingAccNo) return;
  const f = document.getElementById('edit-form');
  const data = {
    holderName: f.holderName.value.trim(),
    email:      f.email.value.trim(),
    phone:      f.phone.value.trim(),
    status:     f.status.value
  };

  ajax({
    method: 'PUT', url: API.ACCOUNTS + '/' + editingAccNo, data,
    onSuccess() {
      toast('Account updated', 'success');
      closeEditModal(); loadAccounts();
    },
    onError(res) { toast(res.message || 'Update failed', 'error'); }
  });
}

// ── Delete Account ────────────────────────────────────────────────────────────

function deleteAccount(accNo) {
  if (!confirm('Delete account ' + accNo + '? This cannot be undone.')) return;
  ajax({
    method: 'DELETE', url: API.ACCOUNTS + '/' + accNo,
    onSuccess() { toast('Account deleted', 'info'); loadAccounts(); },
    onError(res) { toast(res.message || 'Delete failed', 'error'); }
  });
}

// ── Transaction Modal (Deposit / Withdraw) ────────────────────────────────────

let txModalAccNo = null;

function openTxModal(accNo) {
  txModalAccNo = accNo;
  document.getElementById('tx-modal-acc-no').textContent = accNo;
  document.getElementById('tx-form').reset();
  document.getElementById('modal-tx').classList.add('open');
}
function closeTxModal() {
  document.getElementById('modal-tx').classList.remove('open');
  txModalAccNo = null;
}

function submitTransaction() {
  if (!txModalAccNo) return;
  const f = document.getElementById('tx-form');
  const data = {
    type:          f.txType.value,
    accountNumber: txModalAccNo,
    amount:        f.amount.value,
    description:   f.description.value.trim()
  };

  if (!data.amount || parseFloat(data.amount) <= 0) {
    toast('Enter a valid amount', 'error'); return;
  }

  const btn = document.getElementById('btn-tx-submit');
  btn.disabled = true; btn.innerHTML = '<span class="spinner"></span>';

  ajax({
    method: 'POST', url: API.TRANSACTIONS, data,
    onSuccess(res) {
      toast(res.message, 'success');
      closeTxModal(); loadAccounts(); loadDashboard();
      btn.disabled = false; btn.innerHTML = '✓ Submit';
    },
    onError(res) {
      toast(res.message || 'Transaction failed', 'error');
      btn.disabled = false; btn.innerHTML = '✓ Submit';
    }
  });
}

// ── Transactions Page ─────────────────────────────────────────────────────────

function loadTransactions(accFilter = '') {
  const url = accFilter ? API.TRANSACTIONS + '/' + accFilter : API.TRANSACTIONS;
  ajax({
    url,
    onSuccess(data) { renderTransactionsTable(data); },
    onError() { toast('Failed to load transactions', 'error'); }
  });
}

function renderTransactionsTable(data) {
  const tbody = document.getElementById('tx-tbody');
  if (!data || data.length === 0) {
    tbody.innerHTML = `<tr><td colspan="7">
      <div class="empty"><div class="empty-icon">📋</div>No transactions found</div>
    </td></tr>`;
    return;
  }

  const reversed = [...data].reverse();
  tbody.innerHTML = reversed.map(t => `
    <tr>
      <td class="acc-number" style="font-size:11px">${t.transactionId}</td>
      <td><span class="badge badge-${t.type.toLowerCase()}">${t.type}</span></td>
      <td class="acc-number">${t.fromAccount}</td>
      <td class="acc-number">${t.toAccount !== t.fromAccount ? t.toAccount : '—'}</td>
      <td class="${t.type==='WITHDRAW'?'amount-neg':'amount-pos'}">${formatINR(t.amount)}</td>
      <td style="color:var(--text-muted);font-size:12px">${t.description || '—'}</td>
      <td style="color:var(--text-muted);font-size:12px">${t.createdAt}</td>
    </tr>
  `).join('');
}

// ── Transfer Page ─────────────────────────────────────────────────────────────

function populateTransferDropdowns() {
  const from = document.getElementById('transfer-from');
  const to   = document.getElementById('transfer-to');
  if (!from || !to) return;

  const activeAccs = allAccounts.filter(a => a.status === 'ACTIVE');
  const opts = activeAccs.map(a =>
    `<option value="${a.accountNumber}">${a.accountNumber} — ${a.holderName}</option>`
  ).join('');

  from.innerHTML = '<option value="">Select source account</option>' + opts;
  to.innerHTML   = '<option value="">Select destination account</option>' + opts;
}

function updateFromBalance() {
  const sel = document.getElementById('transfer-from').value;
  const acc = allAccounts.find(a => a.accountNumber === sel);
  document.getElementById('from-balance-display').textContent =
    acc ? 'Balance: ' + formatINR(acc.balance) : '';
}

function submitTransfer() {
  const fromAcc = document.getElementById('transfer-from').value;
  const toAcc   = document.getElementById('transfer-to').value;
  const amount  = document.getElementById('transfer-amount').value;
  const desc    = document.getElementById('transfer-desc').value.trim();

  if (!fromAcc || !toAcc) { toast('Select both accounts', 'error'); return; }
  if (fromAcc === toAcc)  { toast('Cannot transfer to same account', 'error'); return; }
  if (!amount || parseFloat(amount) <= 0) { toast('Enter valid amount', 'error'); return; }

  const btn = document.getElementById('btn-transfer-submit');
  btn.disabled = true; btn.innerHTML = '<span class="spinner"></span> Processing…';

  ajax({
    method: 'POST', url: API.TRANSACTIONS,
    data: { type: 'TRANSFER', accountNumber: fromAcc,
            toAccountNumber: toAcc, amount, description: desc },
    onSuccess(res) {
      toast(res.message, 'success');
      document.getElementById('transfer-form').reset();
      document.getElementById('from-balance-display').textContent = '';
      loadAccounts();
      btn.disabled = false; btn.innerHTML = '⇄ Transfer Funds';
    },
    onError(res) {
      toast(res.message || 'Transfer failed', 'error');
      btn.disabled = false; btn.innerHTML = '⇄ Transfer Funds';
    }
  });
}

// ── Helpers ───────────────────────────────────────────────────────────────────

function formatINR(n) {
  if (n == null) return '₹0.00';
  return '₹' + Number(n).toLocaleString('en-IN', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
}

// ── Filter wiring ─────────────────────────────────────────────────────────────

document.addEventListener('DOMContentLoaded', () => {
  startClock();
  navigate('dashboard');

  // Account search
  const searchInp = document.getElementById('acc-search');
  const typeSelect = document.getElementById('acc-type-filter');
  if (searchInp) {
    searchInp.addEventListener('input', () =>
      renderAccountsTable(allAccounts, searchInp.value, typeSelect ? typeSelect.value : ''));
  }
  if (typeSelect) {
    typeSelect.addEventListener('change', () =>
      renderAccountsTable(allAccounts, searchInp ? searchInp.value : '', typeSelect.value));
  }

  // Tx account filter
  const txAccFilter = document.getElementById('tx-acc-filter');
  if (txAccFilter) {
    txAccFilter.addEventListener('change', () => loadTransactions(txAccFilter.value));
  }

  // Modal click-outside
  document.querySelectorAll('.modal-overlay').forEach(overlay => {
    overlay.addEventListener('click', e => {
      if (e.target === overlay) overlay.classList.remove('open');
    });
  });
});
