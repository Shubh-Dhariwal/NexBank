<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>NexBank — Contact Us</title>
  <meta name="description" content="Get in touch with NexBank support team"/>
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

    html, body {
      min-height: 100%; font-family: 'DM Sans', sans-serif;
      background: linear-gradient(135deg, #060e1a 0%, #0a1628 30%, #0f2040 60%, #0b1a30 100%);
      color: var(--text);
    }

    /* ── Navbar ──────────────────────────────────────────── */
    .navbar {
      position: sticky; top: 0; z-index: 100;
      display: flex; align-items: center; justify-content: space-between;
      padding: 0 40px; height: 68px;
      background: rgba(10,22,40,0.85);
      backdrop-filter: blur(16px);
      border-bottom: 1px solid var(--border);
    }
    .nav-brand {
      display: flex; align-items: center; gap: 12px;
    }
    .nav-logo {
      width: 36px; height: 36px;
      background: linear-gradient(135deg, var(--gold), var(--gold-light));
      border-radius: 9px; display: flex; align-items: center; justify-content: center;
      font-size: 18px;
    }
    .nav-brand h2 {
      font-family: 'Playfair Display', serif; font-size: 20px;
      color: var(--gold-light);
    }
    .nav-links { display: flex; gap: 28px; }
    .nav-links a {
      color: var(--text-muted); text-decoration: none; font-size: 14px;
      font-weight: 500; transition: color 0.2s; position: relative;
    }
    .nav-links a:hover, .nav-links a.active { color: var(--gold-light); }
    .nav-links a.active::after {
      content: ''; position: absolute; bottom: -4px; left: 0; right: 0;
      height: 2px; background: linear-gradient(90deg, var(--gold), var(--gold-light));
      border-radius: 2px;
    }

    /* ── Hero ────────────────────────────────────────────── */
    .hero {
      text-align: center; padding: 60px 24px 40px;
    }
    .hero h1 {
      font-family: 'Playfair Display', serif; font-size: 42px;
      background: linear-gradient(135deg, var(--gold-light), var(--gold-pale));
      -webkit-background-clip: text; -webkit-text-fill-color: transparent;
      background-clip: text; margin-bottom: 12px;
    }
    .hero p { color: var(--text-muted); font-size: 16px; max-width: 500px; margin: 0 auto; }

    /* ── Content ─────────────────────────────────────────── */
    .content-grid {
      display: grid; grid-template-columns: 1fr 1fr;
      gap: 32px; max-width: 1060px; margin: 0 auto;
      padding: 0 40px 60px;
    }

    /* ── Contact Info Cards ──────────────────────────────── */
    .info-section { display: flex; flex-direction: column; gap: 16px; }
    .info-card {
      background: var(--card-bg);
      backdrop-filter: blur(16px);
      border: 1px solid var(--border);
      border-radius: 14px; padding: 24px;
      display: flex; align-items: flex-start; gap: 18px;
      transition: all 0.25s ease;
    }
    .info-card:hover {
      border-color: rgba(201,162,39,0.25);
      transform: translateY(-2px);
      box-shadow: 0 8px 32px rgba(0,0,0,0.3);
    }
    .info-icon {
      width: 48px; height: 48px; min-width: 48px;
      background: rgba(201,162,39,0.1);
      border: 1px solid rgba(201,162,39,0.2);
      border-radius: 12px; display: flex; align-items: center; justify-content: center;
      font-size: 22px;
    }
    .info-card h3 { font-size: 15px; font-weight: 600; margin-bottom: 4px; color: var(--text); }
    .info-card p { font-size: 14px; color: var(--text-muted); line-height: 1.5; }

    /* ── Contact Form ───────────────────────────────────── */
    .form-card {
      background: var(--card-bg);
      backdrop-filter: blur(16px);
      border: 1px solid rgba(201,162,39,0.15);
      border-radius: 16px; padding: 36px;
      box-shadow: 0 16px 60px rgba(0,0,0,0.35);
    }
    .form-card h2 {
      font-family: 'Playfair Display', serif; font-size: 22px;
      color: var(--gold-light); margin-bottom: 6px;
    }
    .form-card .subtitle {
      font-size: 13px; color: var(--text-muted); margin-bottom: 28px;
    }
    .form-group { margin-bottom: 20px; }
    .form-group label {
      display: block; font-size: 11px; font-weight: 500;
      color: var(--text-muted); letter-spacing: 0.6px;
      margin-bottom: 7px; text-transform: uppercase;
    }
    .form-group input, .form-group textarea {
      width: 100%; padding: 12px 16px;
      background: rgba(255,255,255,0.04);
      border: 1px solid var(--border); border-radius: 10px;
      color: var(--text); font-family: 'DM Sans', sans-serif; font-size: 14px;
      outline: none; transition: all 0.25s ease; resize: vertical;
    }
    .form-group input:focus, .form-group textarea:focus {
      border-color: rgba(201,162,39,0.5);
      background: rgba(201,162,39,0.04);
      box-shadow: 0 0 16px rgba(201,162,39,0.06);
    }
    .form-group input::placeholder, .form-group textarea::placeholder {
      color: rgba(138,155,181,0.5);
    }
    .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }

    .btn-send {
      width: 100%; padding: 14px; border: none; border-radius: 10px;
      background: linear-gradient(135deg, var(--gold), var(--gold-light));
      color: var(--navy); font-family: 'DM Sans', sans-serif;
      font-size: 15px; font-weight: 700; letter-spacing: 0.5px;
      cursor: pointer; transition: all 0.25s ease;
      box-shadow: 0 4px 20px rgba(201,162,39,0.25);
    }
    .btn-send:hover {
      filter: brightness(1.1); transform: translateY(-2px);
      box-shadow: 0 8px 30px rgba(201,162,39,0.35);
    }

    /* ── Toast ───────────────────────────────────────────── */
    .toast-msg {
      display: none; margin-top: 16px; padding: 12px 16px;
      border-radius: 10px; text-align: center; font-size: 14px;
      background: rgba(26,158,108,0.15); border: 1px solid rgba(26,158,108,0.3);
      color: #22c78a; animation: fadeIn 0.3s ease;
    }
    @keyframes fadeIn { from { opacity: 0; transform: translateY(6px); } to { opacity: 1; transform: none; } }

    /* ── Footer ──────────────────────────────────────────── */
    .footer {
      text-align: center; padding: 32px; font-size: 13px;
      color: var(--text-muted); border-top: 1px solid var(--border);
    }
    .footer span { color: var(--gold); }

    @media (max-width: 768px) {
      .content-grid { grid-template-columns: 1fr; padding: 0 20px 40px; }
      .form-row { grid-template-columns: 1fr; }
      .hero h1 { font-size: 32px; }
      .navbar { padding: 0 20px; }
      .nav-links { gap: 16px; }
    }
  </style>
</head>
<body>

<nav class="navbar">
  <div class="nav-brand">
    <div class="nav-logo">🏦</div>
    <h2>NexBank</h2>
  </div>
  <div class="nav-links">
    <a href="index.jsp">Home</a>
    <a href="contact.jsp" class="active">Contact</a>
    <a href="feedback.jsp">Feedback</a>
  </div>
</nav>

<section class="hero">
  <h1>Get In Touch</h1>
  <p>Have questions or need assistance? Our dedicated support team is here to help you with anything you need.</p>
</section>

<div class="content-grid">
  <div class="info-section">
    <div class="info-card">
      <div class="info-icon">✉</div>
      <div>
        <h3>Email Support</h3>
        <p>support@nexbank.com<br/>We respond within 24 hours</p>
      </div>
    </div>
    <div class="info-card">
      <div class="info-icon">📞</div>
      <div>
        <h3>Phone Support</h3>
        <p>+91 9999999999<br/>Toll-free: 1800-NEX-BANK</p>
      </div>
    </div>
    <div class="info-card">
      <div class="info-icon">📍</div>
      <div>
        <h3>Head Office</h3>
        <p>NexBank Tower, BKC<br/>Mumbai Financial District, 400051</p>
      </div>
    </div>
    <div class="info-card">
      <div class="info-icon">🕐</div>
      <div>
        <h3>Working Hours</h3>
        <p>Monday – Saturday<br/>9:00 AM – 6:00 PM IST</p>
      </div>
    </div>
  </div>

  <div class="form-card">
    <h2>Send Us a Message</h2>
    <p class="subtitle">Fill in the form and we'll get back to you shortly</p>

    <form id="contact-form" onsubmit="return handleSubmit(event)">
      <div class="form-row">
        <div class="form-group">
          <label for="contact-name">Your Name</label>
          <input type="text" id="contact-name" placeholder="Rahul Sharma" required/>
        </div>
        <div class="form-group">
          <label for="contact-email">Email Address</label>
          <input type="email" id="contact-email" placeholder="email@example.com" required/>
        </div>
      </div>
      <div class="form-group">
        <label for="contact-subject">Subject</label>
        <input type="text" id="contact-subject" placeholder="How can we help you?" required/>
      </div>
      <div class="form-group">
        <label for="contact-message">Message</label>
        <textarea id="contact-message" rows="5" placeholder="Tell us more about your query..." required></textarea>
      </div>
      <button type="submit" class="btn-send">✉  Send Message</button>
      <div class="toast-msg" id="contact-toast">✓  Message sent successfully! We'll get back to you soon.</div>
    </form>
  </div>
</div>

<footer class="footer">
  © 2026 <span>NexBank</span>. All rights reserved. | Banking Management System
</footer>

<script>
  function handleSubmit(e) {
    e.preventDefault();
    var toast = document.getElementById('contact-toast');
    toast.style.display = 'block';
    document.getElementById('contact-form').reset();
    setTimeout(function() { toast.style.display = 'none'; }, 4000);
    return false;
  }
</script>

</body>
</html>