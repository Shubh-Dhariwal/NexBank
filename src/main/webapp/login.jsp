<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>NexBank — Sign In</title>
  <meta name="description" content="Sign in to NexBank Banking Management System"/>
  <link rel="preconnect" href="https://fonts.googleapis.com"/>
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet"/>
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

    :root {
      --navy: #0a1628; --navy-light: #0f2040; --navy-mid: #142952;
      --gold: #c9a227; --gold-light: #e5c060; --gold-pale: #f5e6b0;
      --text: #e8edf5; --text-muted: #8a9bb5;
      --border: rgba(255,255,255,0.08);
      --card-bg: rgba(15,32,64,0.65);
    }

    html, body { height: 100%; font-family: 'DM Sans', sans-serif; overflow: hidden; }

    .bg {
      position: fixed; inset: 0; z-index: 0;
      background: linear-gradient(135deg, #060e1a 0%, #0a1628 30%, #0f2040 60%, #0b1a30 100%);
    }
    .bg::before {
      content: ''; position: absolute; inset: 0;
      background:
        radial-gradient(ellipse 600px 400px at 20% 30%, rgba(201,162,39,0.08) 0%, transparent 70%),
        radial-gradient(ellipse 500px 500px at 80% 70%, rgba(58,123,213,0.06) 0%, transparent 70%);
      animation: bgPulse 8s ease-in-out infinite alternate;
    }
    @keyframes bgPulse { 0% { opacity: 0.6; } 100% { opacity: 1; } }

    .particles { position: fixed; inset: 0; z-index: 1; overflow: hidden; pointer-events: none; }
    .particle {
      position: absolute; border-radius: 50%;
      background: radial-gradient(circle, rgba(201,162,39,0.3), transparent 70%);
      animation: float linear infinite;
    }
    @keyframes float {
      0% { transform: translateY(100vh) rotate(0deg); opacity: 0; }
      10% { opacity: 1; } 90% { opacity: 1; }
      100% { transform: translateY(-10vh) rotate(720deg); opacity: 0; }
    }

    .container {
      position: relative; z-index: 10;
      display: flex; align-items: center; justify-content: center;
      min-height: 100vh; padding: 24px;
    }

    .login-card {
      width: 440px; max-width: 100%;
      background: var(--card-bg);
      backdrop-filter: blur(24px) saturate(1.4);
      -webkit-backdrop-filter: blur(24px) saturate(1.4);
      border: 1px solid rgba(201,162,39,0.15);
      border-radius: 20px;
      padding: 48px 40px 40px;
      box-shadow: 0 24px 80px rgba(0,0,0,0.5), 0 0 80px rgba(201,162,39,0.04);
      animation: cardIn 0.6s cubic-bezier(0.16,1,0.3,1) both;
    }
    @keyframes cardIn {
      from { opacity: 0; transform: translateY(24px) scale(0.97); }
      to { opacity: 1; transform: none; }
    }

    .brand { text-align: center; margin-bottom: 36px; }
    .brand-icon {
      width: 56px; height: 56px; margin: 0 auto 16px;
      background: linear-gradient(135deg, var(--gold), var(--gold-light));
      border-radius: 14px; display: flex; align-items: center; justify-content: center;
      font-size: 28px;
      box-shadow: 0 4px 24px rgba(201,162,39,0.3);
    }
    .brand h1 {
      font-family: 'Playfair Display', serif;
      font-size: 28px; color: var(--gold-light);
      letter-spacing: 1px;
    }
    .brand span {
      display: block; font-size: 11px; color: var(--text-muted);
      letter-spacing: 3px; margin-top: 4px;
    }

    .form-group { margin-bottom: 22px; }
    .form-group label {
      display: block; font-size: 12px; font-weight: 500;
      color: var(--text-muted); letter-spacing: 0.6px;
      margin-bottom: 8px; text-transform: uppercase;
    }
    .input-wrap { position: relative; }
    .input-wrap .icon {
      position: absolute; left: 14px; top: 50%; transform: translateY(-50%);
      font-size: 16px; opacity: 0.4; pointer-events: none;
      transition: opacity 0.2s;
    }
    .input-wrap input {
      width: 100%; padding: 13px 16px 13px 44px;
      background: rgba(255,255,255,0.04);
      border: 1px solid var(--border); border-radius: 10px;
      color: var(--text); font-family: 'DM Sans', sans-serif; font-size: 15px;
      outline: none; transition: all 0.25s ease;
    }
    .input-wrap input:focus {
      border-color: rgba(201,162,39,0.5);
      background: rgba(201,162,39,0.05);
      box-shadow: 0 0 20px rgba(201,162,39,0.08);
    }
    .input-wrap input:focus ~ .icon { opacity: 0.8; }
    .input-wrap input::placeholder { color: rgba(138,155,181,0.5); }

    .form-options {
      display: flex; align-items: center; justify-content: space-between;
      margin-bottom: 28px; font-size: 13px;
    }
    .remember {
      display: flex; align-items: center; gap: 8px;
      color: var(--text-muted); cursor: pointer;
    }
    .remember input[type="checkbox"] {
      appearance: none; -webkit-appearance: none;
      width: 16px; height: 16px; border: 1px solid rgba(255,255,255,0.15);
      border-radius: 4px; background: rgba(255,255,255,0.04);
      cursor: pointer; transition: all 0.2s; position: relative;
    }
    .remember input[type="checkbox"]:checked {
      background: linear-gradient(135deg, var(--gold), var(--gold-light));
      border-color: var(--gold);
    }
    .remember input[type="checkbox"]:checked::after {
      content: '✓'; position: absolute; top: -1px; left: 2px;
      font-size: 12px; color: var(--navy); font-weight: 700;
    }
    .forgot {
      color: var(--gold); text-decoration: none; font-weight: 500;
      transition: color 0.2s;
    }
    .forgot:hover { color: var(--gold-light); }

    .btn-signin {
      width: 100%; padding: 14px; border: none; border-radius: 10px;
      background: linear-gradient(135deg, var(--gold), var(--gold-light));
      color: var(--navy); font-family: 'DM Sans', sans-serif;
      font-size: 15px; font-weight: 700; letter-spacing: 0.5px;
      cursor: pointer; transition: all 0.25s ease;
      box-shadow: 0 4px 20px rgba(201,162,39,0.25);
    }
    .btn-signin:hover {
      filter: brightness(1.1);
      transform: translateY(-2px);
      box-shadow: 0 8px 30px rgba(201,162,39,0.35);
    }
    .btn-signin:active { transform: translateY(0); }

    .divider {
      display: flex; align-items: center; gap: 16px;
      margin: 28px 0; color: var(--text-muted); font-size: 12px;
      letter-spacing: 1px;
    }
    .divider::before, .divider::after {
      content: ''; flex: 1; height: 1px;
      background: linear-gradient(90deg, transparent, var(--border), transparent);
    }

    .card-footer {
      text-align: center; font-size: 14px; color: var(--text-muted);
    }
    .card-footer a {
      color: var(--gold-light); text-decoration: none; font-weight: 600;
      transition: color 0.2s;
    }
    .card-footer a:hover { color: var(--gold-pale); }

    .page-links {
      text-align: center; margin-top: 20px; font-size: 13px;
    }
    .page-links a {
      color: var(--text-muted); text-decoration: none; margin: 0 12px;
      transition: color 0.2s;
    }
    .page-links a:hover { color: var(--gold-light); }

    @media (max-width: 480px) {
      .login-card { padding: 36px 24px 32px; }
      .brand h1 { font-size: 24px; }
    }
  </style>
</head>
<body>

<div class="bg"></div>

<div class="particles" id="particles"></div>

<div class="container">
  <div>
    <div class="login-card">
      <div class="brand">
        <div class="brand-icon">🏦</div>
        <h1>NexBank</h1>
        <span>MANAGEMENT SYSTEM</span>
      </div>

      <form action="index.jsp" method="get" id="login-form">
        <div class="form-group">
          <label for="username">Username</label>
          <div class="input-wrap">
            <input type="text" id="username" name="username" placeholder="Enter your username" autocomplete="username"/>
            <span class="icon">👤</span>
          </div>
        </div>

        <div class="form-group">
          <label for="password">Password</label>
          <div class="input-wrap">
            <input type="password" id="password" name="password" placeholder="Enter your password" autocomplete="current-password"/>
            <span class="icon">🔒</span>
          </div>
        </div>

        <div class="form-options">
          <label class="remember">
            <input type="checkbox" name="remember"/>
            Remember me
          </label>
          <a href="#" class="forgot">Forgot password?</a>
        </div>

        <button type="submit" class="btn-signin" id="btn-signin">Sign In</button>
      </form>

      <div class="divider">OR</div>

      <div class="card-footer">
        Don't have an account? <a href="signup.jsp">Create one</a>
      </div>
    </div>

    <div class="page-links">
      <a href="contact.jsp">Contact</a>
      <a href="feedback.jsp">Feedback</a>
    </div>
  </div>
</div>

<script>
  // Generate floating particles
  (function() {
    var container = document.getElementById('particles');
    for (var i = 0; i < 20; i++) {
      var p = document.createElement('div');
      p.className = 'particle';
      var size = Math.random() * 4 + 2;
      p.style.width = size + 'px';
      p.style.height = size + 'px';
      p.style.left = Math.random() * 100 + '%';
      p.style.animationDuration = (Math.random() * 15 + 10) + 's';
      p.style.animationDelay = (Math.random() * 10) + 's';
      container.appendChild(p);
    }
  })();
</script>

</body>
</html>