# NexBank — Banking Management System

A full-stack banking management web application built with:
- **Java Servlets** (AJAX REST API)
- **JSP** (Server-side templating)
- **HTML5 / CSS3** (Dark luxury UI)
- **Vanilla JavaScript** (XMLHttpRequest AJAX, no frameworks)
- **Apache Tomcat 9/10**

No external database required — uses an in-memory data store pre-seeded with demo accounts.

---

## 📁 Project Structure

```
BankingSystem/
├── pom.xml
└── src/main/
    ├── java/com/banking/
    │   ├── model/
    │   │   ├── Account.java
    │   │   └── Transaction.java
    │   ├── util/
    │   │   ├── DataStore.java       ← In-memory singleton DB
    │   │   └── JsonUtil.java        ← Manual JSON serialization
    │   └── servlet/
    │       ├── AccountServlet.java  ← GET/POST/PUT/DELETE /api/accounts
    │       ├── TransactionServlet.java  ← GET/POST /api/transactions
    │       ├── DashboardServlet.java    ← GET /api/dashboard
    │       └── CharsetFilter.java
    └── webapp/
        ├── index.jsp            ← Single-page app shell
        ├── css/style.css
        ├── js/main.js           ← All AJAX + UI logic
        └── WEB-INF/web.xml
```

---

## 🚀 Running with Maven + Tomcat

### Option A — Maven Embedded Tomcat (quickest)

```bash
cd BankingSystem
mvn tomcat7:run
```
Open: http://localhost:8080/banking

### Option B — Deploy WAR to Tomcat

```bash
# 1. Build the WAR
mvn clean package

# 2. Copy to Tomcat webapps folder
cp target/BankingSystem.war $CATALINA_HOME/webapps/

# 3. Start Tomcat
$CATALINA_HOME/bin/startup.sh    # Linux/Mac
$CATALINA_HOME\bin\startup.bat   # Windows
```
Open: http://localhost:8080/BankingSystem

### Option C — IntelliJ IDEA / Eclipse

1. Import as Maven project
2. Add Tomcat server configuration
3. Deploy artifact → `BankingSystem:war`
4. Run on Tomcat

---

## 🌐 REST API Endpoints

| Method | URL | Description |
|--------|-----|-------------|
| GET | /api/dashboard | Dashboard stats + recent data |
| GET | /api/accounts | List all accounts |
| GET | /api/accounts/{accNo} | Get account by number |
| POST | /api/accounts | Create new account |
| PUT | /api/accounts/{accNo} | Update account |
| DELETE | /api/accounts/{accNo} | Delete account |
| GET | /api/transactions | All transactions |
| GET | /api/transactions/{accNo} | Transactions for account |
| POST | /api/transactions | Perform DEPOSIT / WITHDRAW / TRANSFER |

### POST /api/transactions Parameters

| Param | Values | Required |
|-------|--------|----------|
| type | DEPOSIT, WITHDRAW, TRANSFER | ✓ |
| accountNumber | ACC00000001 | ✓ |
| toAccountNumber | ACC00000002 | For TRANSFER only |
| amount | numeric | ✓ |
| description | text | Optional |

---

## 🎯 Features

- **Dashboard** — Real-time stats, recent accounts & transactions
- **Account Management** — Create, edit, delete, search & filter accounts
- **Deposit / Withdraw** — Per-account transactions via modal
- **Fund Transfer** — Between any two active accounts
- **Transaction History** — Full audit log with filter by account
- **Status Management** — ACTIVE / INACTIVE / FROZEN
- **AJAX everywhere** — Zero page reloads, all via XMLHttpRequest
- **Seeded demo data** — 4 accounts + 7 transactions pre-loaded

---

## 📦 Requirements

- Java 11+
- Maven 3.6+
- Apache Tomcat 9.x or 10.x (or use embedded via Maven plugin)
