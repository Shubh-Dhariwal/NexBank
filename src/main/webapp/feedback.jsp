<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>NexBank — Share Your Feedback</title>
  <meta name="description" content="Help us improve NexBank with your valuable feedback"/>
  <link rel="preconnect" href="https://fonts.googleapis.com"/>
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet"/>
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

    :root {
      --navy: #0a1628; --navy-light: #0f2040; --navy-mid: #142952;
      --gold: #c9a227; --gold-light: #e5c060; --gold-pale: #f5e6b0;
      --emerald: #1a9e6c; --emerald-lt: #22c78a;
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
    .nav-brand { display: flex; align-items: center; gap: 12px; }
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
    .hero { text-align: center; padding: 56px 24px 36px; }
    .hero h1 {
      font-family: 'Playfair Display', serif; font-size: 42px;
      background: linear-gradient(135deg, var(--gold-light), var(--gold-pale));
      -webkit-background-clip: text; -webkit-text-fill-color: transparent;
      background-clip: text; margin-bottom: 12px;
    }
    .hero p { color: var(--text-muted); font-size: 16px; max-width: 520px; margin: 0 auto; line-height: 1.6; }

    /* ── Feedback Form Card ─────────────────────────────── */
    .form-wrapper {
      max-width: 600px; margin: 0 auto; padding: 0 24px 40px;
    }
    .form-card {
      background: var(--card-bg);
      backdrop-filter: blur(20px);
      border: 1px solid rgba(201,162,39,0.15);
      border-radius: 18px; padding: 40px;
      box-shadow: 0 20px 70px rgba(0,0,0,0.4), 0 0 60px rgba(201,162,39,0.03);
      animation: cardIn 0.5s cubic-bezier(0.16,1,0.3,1) both;
    }
    @keyframes cardIn {
      from { opacity: 0; transform: translateY(20px); }
      to { opacity: 1; transform: none; }
    }

    /* ── Star Rating ────────────────────────────────────── */
    .rating-section { text-align: center; margin-bottom: 28px; }
    .rating-label {
      font-size: 13px; color: var(--text-muted); margin-bottom: 14px;
      letter-spacing: 0.4px;
    }
    .stars { display: flex; justify-content: center; gap: 8px; }
    .star {
      font-size: 36px; cursor: pointer;
      color: rgba(255,255,255,0.12);
      transition: all 0.2s ease;
      user-select: none;
    }
    .star:hover { transform: scale(1.2); }
    .star.active { color: var(--gold-light); text-shadow: 0 0 20px rgba(201,162,39,0.4); }
    .star.hover-preview { color: var(--gold); }
    .rating-text {
      font-size: 13px; color: var(--gold-light); margin-top: 10px;
      min-height: 20px; font-weight: 500;
    }

    /* ── Form Fields ────────────────────────────────────── */
    .form-group { margin-bottom: 22px; }
    .form-group label {
      display: block; font-size: 11px; font-weight: 500;
      color: var(--text-muted); letter-spacing: 0.6px;
      margin-bottom: 8px; text-transform: uppercase;
    }
    .form-group select,
    .form-group textarea {
      width: 100%; padding: 12px 16px;
      background: rgba(255,255,255,0.04);
      border: 1px solid var(--border); border-radius: 10px;
      color: var(--text); font-family: 'DM Sans', sans-serif; font-size: 14px;
      outline: none; transition: all 0.25s ease; resize: vertical;
    }
    .form-group select option { background: var(--navy-light); color: var(--text); }
    .form-group select:focus,
    .form-group textarea:focus {
      border-color: rgba(201,162,39,0.5);
      background: rgba(201,162,39,0.04);
      box-shadow: 0 0 16px rgba(201,162,39,0.06);
    }
    .form-group textarea::placeholder { color: rgba(138,155,181,0.5); }

    .btn-submit {
      width: 100%; padding: 14px; border: none; border-radius: 10px;
      background: linear-gradient(135deg, var(--gold), var(--gold-light));
      color: var(--navy); font-family: 'DM Sans', sans-serif;
      font-size: 15px; font-weight: 700; letter-spacing: 0.5px;
      cursor: pointer; transition: all 0.25s ease;
      box-shadow: 0 4px 20px rgba(201,162,39,0.25);
    }
    .btn-submit:hover {
      filter: brightness(1.1); transform: translateY(-2px);
      box-shadow: 0 8px 30px rgba(201,162,39,0.35);
    }
    .btn-submit:active { transform: translateY(0); }

    .toast-msg {
      display: none; margin-top: 18px; padding: 14px 18px;
      border-radius: 10px; text-align: center; font-size: 14px;
      background: rgba(26,158,108,0.15); border: 1px solid rgba(26,158,108,0.3);
      color: var(--emerald-lt); animation: fadeUp 0.35s ease;
    }
    @keyframes fadeUp { from { opacity:0; transform:translateY(8px); } to { opacity:1; transform:none; } }

    /* ── Stats Section ──────────────────────────────────── */
    .stats-section {
      display: grid; grid-template-columns: repeat(3, 1fr);
      gap: 20px; max-width: 700px; margin: 20px auto 0;
      padding: 0 24px 60px;
    }
    .stat-card {
      background: var(--card-bg);
      backdrop-filter: blur(16px);
      border: 1px solid var(--border);
      border-radius: 14px; padding: 28px 20px;
      text-align: center; transition: all 0.25s ease;
    }
    .stat-card:hover {
      border-color: rgba(201,162,39,0.2);
      transform: translateY(-4px);
      box-shadow: 0 12px 40px rgba(0,0,0,0.3);
    }
    .stat-icon { font-size: 32px; margin-bottom: 12px; }
    .stat-value {
      font-family: 'Playfair Display', serif; font-size: 24px;
      color: var(--gold-light); margin-bottom: 4px;
    }
    .stat-label { font-size: 12px; color: var(--text-muted); letter-spacing: 0.3px; }

    /* ── Footer ──────────────────────────────────────────── */
    .footer {
      text-align: center; padding: 32px; font-size: 13px;
      color: var(--text-muted); border-top: 1px solid var(--border);
    }
    .footer span { color: var(--gold); }

    @media (max-width: 768px) {
      .hero h1 { font-size: 30px; }
      .form-card { padding: 28px 20px; }
      .stats-section { grid-template-columns: 1fr; max-width: 320px; }
      .navbar { padding: 0 20px; }
      .nav-links { gap: 16px; }
      .star { font-size: 30px; }
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
    <a href="contact.jsp">Contact</a>
    <a href="feedback.jsp" class="active">Feedback</a>
  </div>
</nav>

<section class="hero">
  <h1>Share Your Feedback</h1>
  <p>Your experience matters to us. Help us improve our services by sharing your thoughts — every piece of feedback makes NexBank better.</p>
</section>

<div class="form-wrapper">
  <div class="form-card">
    <form id="feedback-form" onsubmit="return handleFeedback(event)">

      <div class="rating-section">
        <div class="rating-label">How would you rate your experience?</div>
        <div class="stars" id="star-rating">
          <span class="star" data-value="1" onclick="setRating(1)" onmouseenter="previewRating(1)" onmouseleave="resetPreview()">★</span>
          <span class="star" data-value="2" onclick="setRating(2)" onmouseenter="previewRating(2)" onmouseleave="resetPreview()">★</span>
          <span class="star" data-value="3" onclick="setRating(3)" onmouseenter="previewRating(3)" onmouseleave="resetPreview()">★</span>
          <span class="star" data-value="4" onclick="setRating(4)" onmouseenter="previewRating(4)" onmouseleave="resetPreview()">★</span>
          <span class="star" data-value="5" onclick="setRating(5)" onmouseenter="previewRating(5)" onmouseleave="resetPreview()">★</span>
        </div>
        <div class="rating-text" id="rating-text"></div>
      </div>

      <div class="form-group">
        <label for="fb-category">Category</label>
        <select id="fb-category" required>
          <option value="">Select a category</option>
          <option value="service">Service Quality</option>
          <option value="app">App Experience</option>
          <option value="support">Customer Support</option>
          <option value="branch">Branch Experience</option>
          <option value="other">Other</option>
        </select>
      </div>

      <div class="form-group">
        <label for="fb-message">Your Feedback</label>
        <textarea id="fb-message" rows="5" placeholder="Tell us what you loved, or what we can improve..." required></textarea>
      </div>

      <button type="submit" class="btn-submit">⭐  Submit Feedback</button>
      <div class="toast-msg" id="fb-toast">✓  Thank you for your feedback! We truly appreciate it.</div>
    </form>
  </div>
</div>

<div class="stats-section">
  <div class="stat-card">
    <div class="stat-icon">🏆</div>
    <div class="stat-value">98%</div>
    <div class="stat-label">Satisfaction Rate</div>
  </div>
  <div class="stat-card">
    <div class="stat-icon">🛡</div>
    <div class="stat-value">24/7</div>
    <div class="stat-label">Support Available</div>
  </div>
  <div class="stat-card">
    <div class="stat-icon">❤</div>
    <div class="stat-value">10,000+</div>
    <div class="stat-label">Happy Customers</div>
  </div>
</div>

<footer class="footer">
  © 2026 <span>NexBank</span>. All rights reserved. | Banking Management System
</footer>

<script>
  var currentRating = 0;
  var ratingLabels = ['', 'Poor', 'Fair', 'Good', 'Very Good', 'Excellent'];

  function setRating(val) {
    currentRating = val;
    var stars = document.querySelectorAll('.star');
    for (var i = 0; i < stars.length; i++) {
      stars[i].classList.toggle('active', i < val);
      stars[i].classList.remove('hover-preview');
    }
    document.getElementById('rating-text').textContent = ratingLabels[val] || '';
  }

  function previewRating(val) {
    var stars = document.querySelectorAll('.star');
    for (var i = 0; i < stars.length; i++) {
      if (i < val && !stars[i].classList.contains('active')) {
        stars[i].classList.add('hover-preview');
      }
    }
  }

  function resetPreview() {
    var stars = document.querySelectorAll('.star');
    for (var i = 0; i < stars.length; i++) {
      stars[i].classList.remove('hover-preview');
    }
  }

  function handleFeedback(e) {
    e.preventDefault();
    if (currentRating === 0) {
      document.getElementById('rating-text').textContent = 'Please select a rating';
      document.getElementById('rating-text').style.color = '#d64045';
      setTimeout(function() {
        document.getElementById('rating-text').style.color = '';
        if (currentRating === 0) document.getElementById('rating-text').textContent = '';
      }, 2000);
      return false;
    }
    var toast = document.getElementById('fb-toast');
    toast.style.display = 'block';
    document.getElementById('feedback-form').reset();
    setRating(0);
    document.getElementById('rating-text').textContent = '';
    setTimeout(function() { toast.style.display = 'none'; }, 4000);
    return false;
  }
</script>

</body>
</html>