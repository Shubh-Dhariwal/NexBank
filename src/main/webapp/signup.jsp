<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>NexBank — Create Account</title>
  <meta name="description" content="Create your NexBank account"/>
  <link rel="preconnect" href="https://fonts.googleapis.com"/>
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet"/>
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

    :root {
      --navy: #0a1628; --navy-light: #0f2040; --navy-mid: #142952;
      --gold: #c9a227; --gold-light: #e5c060; --gold-pale: #f5e6b0;
      --emerald: #1a9e6c; --crimson: #d64045;
      --text: #e8edf5; --text-muted: #8a9bb5;
      --border: rgba(255,255,255,0.08);
      --card-bg: rgba(15,32,64,0.65);
    }

    html, body { height: 100%; font-family: 'DM Sans', sans-serif; overflow-y: auto; overflow-x: hidden; }

    .bg {
      position: fixed; inset: 0; z-index: 0;
      background: linear-gradient(135deg, #060e1a 0%, #0a1628 30%, #0f2040 60%, #0b1a30 100%);
    }
    .bg::before {
      content: ''; position: absolute; inset: 0;
      background:
        radial-gradient(ellipse 600px 400px at 80% 20%, rgba(201,162,39,0.07) 0%, transparent 70%),
        radial-gradient(ellipse 500px 500px at 20% 80%, rgba(58,123,213,0.05) 0%, transparent 70%);
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
      min-height: 100vh; padding: 40px 24px;
    }

    .signup-card {
      width: 500px; max-width: 100%;
      background: var(--card-bg);
      backdrop-filter: blur(24px) saturate(1.4);
      border: 1px solid rgba(201,162,39,0.15);
      border-radius: 20px;
      padding: 44px 40px 36px;
      box-shadow: 0 24px 80px rgba(0,0,0,0.5), 0 0 80px rgba(201,162,39,0.04);
      animation: cardIn 0.6s cubic-bezier(0.16,1,0.3,1) both;
    }
    @keyframes cardIn {
      from { opacity: 0; transform: translateY(24px) scale(0.97); }
      to { opacity: 1; transform: none; }
    }

    .brand { text-align: center; margin-bottom: 32px; }
    .brand-icon {
      width: 52px; height: 52px; margin: 0 auto 14px;
      background: linear-gradient(135deg, var(--gold), var(--gold-light));
      border-radius: 13px; display: flex; align-items: center; justify-content: center;
      font-size: 26px; box-shadow: 0 4px 24px rgba(201,162,39,0.3);
    }
    .brand h1 {
      font-family: 'Playfair Display', serif; font-size: 26px;
      color: var(--gold-light); letter-spacing: 1px;
    }
    .brand span {
      display: block; font-size: 11px; color: var(--text-muted);
      letter-spacing: 3px; margin-top: 4px;
    }

    .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
    .form-row.full { grid-template-columns: 1fr; }

    .form-group { margin-bottom: 20px; }
    .form-group label {
      display: block; font-size: 11px; font-weight: 500;
      color: var(--text-muted); letter-spacing: 0.6px;
      margin-bottom: 7px; text-transform: uppercase;
    }
    .input-wrap { position: relative; }
    .input-wrap .icon {
      position: absolute; left: 13px; top: 50%; transform: translateY(-50%);
      font-size: 15px; opacity: 0.4; pointer-events: none; transition: opacity 0.2s;
    }
    .input-wrap input, .input-wrap select {
      width: 100%; padding: 12px 14px 12px 42px;
      background: rgba(255,255,255,0.04);
      border: 1px solid var(--border); border-radius: 10px;
      color: var(--text); font-family: 'DM Sans', sans-serif; font-size: 14px;
      outline: none; transition: all 0.25s ease;
    }
    .input-wrap input:focus {
      border-color: rgba(201,162,39,0.5);
      background: rgba(201,162,39,0.05);
      box-shadow: 0 0 20px rgba(201,162,39,0.08);
    }
    .input-wrap input:focus ~ .icon { opacity: 0.8; }
    .input-wrap input::placeholder { color: rgba(138,155,181,0.5); }

    .password-strength {
      height: 3px; border-radius: 3px; margin-top: 8px;
      background: rgba(255,255,255,0.06); overflow: hidden;
      transition: all 0.3s;
    }
    .password-strength .bar {
      height: 100%; width: 0; border-radius: 3px;
      transition: width 0.3s, background 0.3s;
    }

    .error-msg {
      font-size: 12px; color: var(--crimson); margin-top: 6px;
      display: none; animation: shake 0.3s ease;
    }
    @keyframes shake { 0%,100%{transform:translateX(0)} 25%{transform:translateX(-4px)} 75%{transform:translateX(4px)} }

    .btn-signup {
      width: 100%; padding: 14px; border: none; border-radius: 10px;
      background: linear-gradient(135deg, var(--gold), var(--gold-light));
      color: var(--navy); font-family: 'DM Sans', sans-serif;
      font-size: 15px; font-weight: 700; letter-spacing: 0.5px;
      cursor: pointer; transition: all 0.25s ease;
      box-shadow: 0 4px 20px rgba(201,162,39,0.25);
      margin-top: 8px;
    }
    .btn-signup:hover {
      filter: brightness(1.1); transform: translateY(-2px);
      box-shadow: 0 8px 30px rgba(201,162,39,0.35);
    }
    .btn-signup:active { transform: translateY(0); }

    .divider {
      display: flex; align-items: center; gap: 16px;
      margin: 24px 0; color: var(--text-muted); font-size: 12px; letter-spacing: 1px;
    }
    .divider::before, .divider::after {
      content: ''; flex: 1; height: 1px;
      background: linear-gradient(90deg, transparent, var(--border), transparent);
    }

    .card-footer { text-align: center; font-size: 14px; color: var(--text-muted); }
    .card-footer a {
      color: var(--gold-light); text-decoration: none; font-weight: 600; transition: color 0.2s;
    }
    .card-footer a:hover { color: var(--gold-pale); }

    .page-links { text-align: center; margin-top: 20px; font-size: 13px; }
    .page-links a { color: var(--text-muted); text-decoration: none; margin: 0 12px; transition: color 0.2s; }
    .page-links a:hover { color: var(--gold-light); }

    @media (max-width: 540px) {
      .signup-card { padding: 32px 20px 28px; }
      .form-row { grid-template-columns: 1fr; }
      .brand h1 { font-size: 22px; }
    }
  </style>
</head>
<body>

<div class="bg"></div>
<div class="particles" id="particles"></div>

<div class="container">
  <div>
    <div class="signup-card">
      <div class="brand">
        <div class="brand-icon">🏦</div>
        <h1>NexBank</h1>
        <span>CREATE ACCOUNT</span>
      </div>

      <form action="login.jsp" method="get" id="signup-form" onsubmit="return validateForm()">
        <div class="form-row full">
          <div class="form-group">
            <label for="fullname">Full Name</label>
            <div class="input-wrap">
              <input type="text" id="fullname" name="fullname" placeholder="e.g. Rahul Sharma" required/>
              <span class="icon">👤</span>
            </div>
          </div>
        </div>

        <div class="form-row">
          <div class="form-group">
            <label for="email">Email Address</label>
            <div class="input-wrap">
              <input type="email" id="email" name="email" placeholder="email@example.com" required/>
              <span class="icon">✉</span>
            </div>
          </div>
          <div class="form-group">
            <label for="reg-username">Username</label>
            <div class="input-wrap">
              <input type="text" id="reg-username" name="username" placeholder="Choose a username" required/>
              <span class="icon">🆔</span>
            </div>
          </div>
        </div>

        <div class="form-row">
          <div class="form-group">
            <label for="reg-password">Password</label>
            <div class="input-wrap">
              <input type="password" id="reg-password" name="password" placeholder="Min 6 characters" required oninput="checkStrength(this.value)"/>
              <span class="icon">🔒</span>
            </div>
            <div class="password-strength"><div class="bar" id="strength-bar"></div></div>
          </div>
          <div class="form-group">
            <label for="confirm-password">Confirm Password</label>
            <div class="input-wrap">
              <input type="password" id="confirm-password" name="confirmPassword" placeholder="Repeat password" required/>
              <span class="icon">🔐</span>
            </div>
            <div class="error-msg" id="password-error">Passwords do not match</div>
          </div>
        </div>

        <button type="submit" class="btn-signup" id="btn-signup">Create Account</button>
      </form>

      <div class="divider">OR</div>

      <div class="card-footer">
        Already have an account? <a href="login.jsp">Sign In</a>
      </div>
    </div>

    <div class="page-links">
      <a href="contact.jsp">Contact</a>
      <a href="feedback.jsp">Feedback</a>
    </div>
  </div>
</div>

<script>
  // Floating particles
  (function() {
    var c = document.getElementById('particles');
    for (var i = 0; i < 16; i++) {
      var p = document.createElement('div');
      p.className = 'particle';
      var s = Math.random() * 4 + 2;
      p.style.width = s + 'px'; p.style.height = s + 'px';
      p.style.left = Math.random() * 100 + '%';
      p.style.animationDuration = (Math.random() * 15 + 10) + 's';
      p.style.animationDelay = (Math.random() * 10) + 's';
      c.appendChild(p);
    }
  })();

  // Password strength indicator
  function checkStrength(val) {
    var bar = document.getElementById('strength-bar');
    var strength = 0;
    if (val.length >= 6) strength++;
    if (val.length >= 10) strength++;
    if (/[A-Z]/.test(val)) strength++;
    if (/[0-9]/.test(val)) strength++;
    if (/[^A-Za-z0-9]/.test(val)) strength++;

    var percent = Math.min(strength * 20, 100);
    var colors = ['#d64045', '#d64045', '#e5c060', '#c9a227', '#1a9e6c', '#22c78a'];
    bar.style.width = percent + '%';
    bar.style.background = colors[strength] || '#d64045';
  }

  // Form validation
  function validateForm() {
    var pw = document.getElementById('reg-password').value;
    var cpw = document.getElementById('confirm-password').value;
    var errEl = document.getElementById('password-error');

    if (pw !== cpw) {
      errEl.style.display = 'block';
      return false;
    }
    if (pw.length < 6) {
      errEl.textContent = 'Password must be at least 6 characters';
      errEl.style.display = 'block';
      return false;
    }
    errEl.style.display = 'none';
    return true;
  }
</script>

</body>
</html>