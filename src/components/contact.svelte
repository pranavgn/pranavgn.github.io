<script>
</script>

<section class="contact-section">
  
  <div class="center-container">
    <a href="mailto:pranavgn@gmail.com" class="mail-link">
      MAIL
    </a>
  </div>

  <div class="social-footer">
    <a href="https://instagram.com" target="_blank" rel="noreferrer">INSTAGRAM</a>
    <a href="https://behance.net" target="_blank" rel="noreferrer">BEHANCE</a>
    <a href="https://vimeo.com" target="_blank" rel="noreferrer">VIMEO</a>
  </div>

</section>

<style>
  .contact-section {
    position: relative;
    width: 100vw;
    height: 85vh;
    background-color: black;
    color: white;
    display: flex;
    flex-direction: column;
    overflow: hidden;
  }

  .center-container {
    flex-grow: 1;
    display: flex;
    justify-content: center;
    align-items: center;
  }

  .mail-link {
    font-family: 'Deuterium-Ultra', sans-serif;
    font-size: 10vw;
    color: white;
    text-decoration: none;
    line-height: 1;
    transition: transform 0.3s cubic-bezier(0.25, 1, 0.5, 1), opacity 0.3s ease;
  }

  .mail-link:hover {
    transform: scale(1.05);
    opacity: 0.8;
    cursor: crosshair;
    text-decoration: underline;
  }

  .social-footer {
    width: 100%;
    box-sizing: border-box;
    padding: 30px 40px;
    
    display: flex;
    justify-content: space-between;
    align-items: flex-end;
  }

  .social-footer a {
    font-family: 'Deuterium-Light', sans-serif;
    font-size: 14px;
    color: white;
    text-decoration: none;
    letter-spacing: 0.1em;
    text-transform: uppercase;
    transition: opacity 0.3s ease;
  }

  .social-footer a:hover {
    opacity: 0.6;
    cursor: crosshair;
  }

  @media (max-width: 768px) {
    .mail-link { font-size: 15vw; }
    .social-footer { padding: 20px; flex-direction: row; font-size: 12px; }
  }
</style>
