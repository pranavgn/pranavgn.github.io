<script>
  import { onMount } from 'svelte';
  import { spring } from 'svelte/motion';
  import { fade } from 'svelte/transition';

  // References
  let headerElement;
  let imageElement;
  let navElement;
  let scrollIndicator; 
  let noiseCanvas;

  // Configuration
  const scrollDistance = '85%'; 

  // NOISE CONFIGURATION VARIABLES
  let noiseOpacity = 0.3; 
  let noiseScale = 1; 
  let noiseSpeed = 24; 
  let noiseIntensity = 80; 
  let noiseContrast = 1.6; 

  // --- INTERACTION STATE ---
  let isPlaying = false;
  let isHoveringTrigger = false;
   
  // Cursor Logic
  let coords = spring({ x: 0, y: 0 }, { stiffness: 0.1, damping: 0.25 });
  function handleMouseMove(e) { coords.set({ x: e.clientX, y: e.clientY }); }

  onMount(async () => {
    const { gsap } = await import('gsap');
    const { ScrollTrigger } = await import('gsap/ScrollTrigger');
    gsap.registerPlugin(ScrollTrigger);
    
    await new Promise(resolve => requestAnimationFrame(resolve));
    
    // 1. Initial Setup 
    // This acts as the "source of truth" before the timeline takes over
    gsap.set(headerElement, { height: '100vh' });
    gsap.set(imageElement, { height: '100%', marginBottom: '0px' }); // Ensure margins are reset here
    gsap.set(navElement, { autoAlpha: 0, y: 10 });
    gsap.set(scrollIndicator, { autoAlpha: 1, y: 0 }); 

    // 2. Timeline
    const timeline = gsap.timeline({
      scrollTrigger: {
        trigger: "body",
        start: "top top",
        end: `+=${scrollDistance}`,
        scrub: true,
        markers: false
      }
    });

    // 3. Animations - Add immediateRender: false
    
    timeline.fromTo(headerElement, 
      { height: '100vh' }, 
      { 
        height: '15vh', 
        ease: "none",
        immediateRender: false // <--- THE FIX
      }, 
      0
    );

    timeline.fromTo(imageElement, 
      { height: '100%', marginBottom: '0px' }, 
      { 
        height: '8vh', 
        marginBottom: '10px', 
        ease: "none",
        immediateRender: false // <--- THE FIX
      }, 
      0
    );
    
    timeline.to(scrollIndicator, {
      autoAlpha: 0,
      y: -20, 
      ease: "power1.out",
      duration: 0.2 
    }, 0);
    
    timeline.to(navElement, {
      autoAlpha: 1,
      y: 0,
      ease: "none"
    }, 0.2);

    // 4. Force a refresh to ensure start/end positions are calculated 
    // correctly after the browser handles the #hash jump
    ScrollTrigger.refresh();
    
    setupNoiseAnimation();
  });

  async function smoothScrollTo(id, e) {
    e.preventDefault(); // Stop the browser from jumping instantly
    
    const { gsap } = await import('gsap');
    const { ScrollToPlugin } = await import('gsap/ScrollToPlugin');
    gsap.registerPlugin(ScrollToPlugin);

    gsap.to(window, {
      duration: 1.2,
      scrollTo: {
        y: id,
        autoKill: false
      },
      ease: "power4.inOut"
    });
  }

  async function scrollToSection(id) {
    const { gsap } = await import('gsap');
    const { ScrollToPlugin } = await import('gsap/ScrollToPlugin');
    gsap.registerPlugin(ScrollToPlugin);

    gsap.to(window, {
      duration: 1.5,          // Slower duration for a cinematic feel
      scrollTo: {
        y: id,
        autoKill: false       // Allows the user to interrupt if they grab the scrollbar
      },
      ease: "power4.inOut"    // The smoothest ease for long-distance scrolling
    });
  }

  function setupNoiseAnimation() {
    if (!noiseCanvas) return;
    
    const ctx = noiseCanvas.getContext('2d');
    const width = noiseCanvas.width;
    const height = noiseCanvas.height;
    
    function generateNoise() {
      const imageData = ctx.createImageData(width, height);
      const buffer = new Uint32Array(imageData.data.buffer);
      
      const len = buffer.length;
      for (let i = 0; i < len; i++) {
        const baseValue = Math.random() * noiseIntensity;
        const contrastAdjusted = Math.pow(baseValue / noiseIntensity, noiseContrast) * noiseIntensity;
        const value = Math.floor(contrastAdjusted);
        buffer[i] = (255 << 24) | (value << 16) | (value << 8) | value;
      }
      ctx.putImageData(imageData, 0, 0);
    }
    
    const interval = 1000 / noiseSpeed;
    setInterval(generateNoise, interval);
    generateNoise(); 
  }
</script>

<svelte:head>
  <style>
    @font-face {
      font-family: 'Deuterium-Light';
      src: url('/fonts/Deuterium-Variable-Thin.ttf'); 
      font-weight: 500;
      font-style: normal;
    }
    @font-face {
      font-family: 'Deuterium-Ultra';
      src: url('/fonts/Deuterium-Variable-Thin.ttf'); 
      font-weight: 900;
      font-style: normal;
    }
  </style>
</svelte:head>

<svelte:window on:mousemove={handleMouseMove} />

{#if isHoveringTrigger && !isPlaying}
  <div 
    class="cursor-play" 
    style="transform: translate({$coords.x}px, {$coords.y}px)"
  >
    PLAY
  </div>
{/if}

{#if isPlaying}
  <div class="overlay" transition:fade={{duration: 200}}>
    <button class="nav-btn close-btn" on:click={() => { isPlaying = false; isHoveringTrigger = false; }}>
      <span class="btn-text">CLOSE</span>
      <svg class="close-svg" viewBox="0 0 20 20">
        <line x1="1" y1="1" x2="19" y2="19" stroke="white" stroke-width="2" />
        <line x1="19" y1="1" x2="1" y2="19" stroke="white" stroke-width="2" />
      </svg>
    </button>
    
    <div class="video-embed-wrapper">
        <iframe 
          src="https://player.vimeo.com/video/1140356214?h=f33abcc2e6&badge=0&autopause=0&player_id=0&app_id=58479&autoplay=1" 
          frameborder="0" 
          allow="autoplay; fullscreen; picture-in-picture; clipboard-write; encrypted-media; web-share" 
          allowfullscreen 
          class="vimeo-embed"
          title="Showreel"
        ></iframe>
    </div>
  </div>
{/if}

<div class="header-ui" bind:this={headerElement}>
  <img
    src="/Title.svg"
    alt="PRANAV NAIR"
    class="hero-img"
    bind:this={imageElement}
  />
  
  <nav class="nav-links" bind:this={navElement}>
    <a href="/" on:click|preventDefault={() => scrollToSection("#work")}>WORK</a>
    <a href="/" on:click|preventDefault={() => scrollToSection("#about")}>ABOUT</a>
    <a href="/" on:click|preventDefault={() => scrollToSection("#contact")}>CONTACT</a>
  </nav>

  <div class="scroll-indicator" bind:this={scrollIndicator}>
    <span class="scroll-text">SCROLL</span>
    <svg class="scroll-arrow" viewBox="0 0 20 60" preserveAspectRatio="none">
        <line class="arrow-line" x1="10" y1="0" x2="10" y2="58" />
        <polyline class="arrow-head" points="2,50 10,58 18,50" />
    </svg>
  </div>
</div>

<div class="scroll-flow">
   
  <div class="video-wrapper">
    <iframe
      src="https://player.vimeo.com/video/1124799064?badge=0&autopause=0&player_id=0&app_id=58479&autoplay=1&loop=1&muted=1&background=1&transparent=0"
      frameborder="0"
      allow="autoplay; fullscreen; picture-in-picture"
      title="Background Video"
      class="bg-iframe"
    ></iframe>
    
    <canvas 
      bind:this={noiseCanvas}
      class="noise-overlay"
      width="400"
      height="400"
      style="opacity: {noiseOpacity}; transform: scale({noiseScale});"
    ></canvas>

    {#if !isPlaying}
      <button 
        class="center-trigger"
        on:mouseenter={() => isHoveringTrigger = true}
        on:mouseleave={() => isHoveringTrigger = false}
        on:click={() => isPlaying = true}
      >
        <img src="/2025/20251.webp" alt="Play Video" class="trigger-img" />
        
        <div class="play-button-overlay">
            <svg viewBox="0 0 60 40" class="play-svg" preserveAspectRatio="none" style="mix-blend-mode: exclusion;">
                <path d="M0 0 L60 20 L0 40 Z" fill="#e2e2e2" />
            </svg>
        </div>
      </button>
    {/if}

  </div>

</div>

<style>
  /* Global Resets */
  :global(html), :global(body) {
    margin: 0;
    padding: 0;
    background-color: #000 !important;
    overflow-x: hidden;
  }

  /* --- FIXED HEADER --- */
  .header-ui {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%; 
    
    display: flex;
    flex-direction: column;
    justify-content: flex-end;
    align-items: center;
    
    z-index: 50;
    background-color: #000;
    overflow: hidden;
    will-change: height;
    box-sizing: border-box;
    padding-bottom: 1vh;
  }

  .hero-img {
    display: block;
    width: 100%; 
    object-fit: fill; 
    will-change: height;
  }

  .nav-links {
    display: flex;
    gap: 60px;
    height: 3vh;
    align-items: center;
    justify-content: center;
  }

  .nav-links a {
    font-family: 'Deuterium-Light', sans-serif;
    color: #fff;
    text-decoration: none;
    font-size: 1rem;
    letter-spacing: 0.2em;
    text-transform: uppercase;
    transition: opacity 0.3s;
  }
   
  .nav-links a:hover {
    opacity: 0.7;
    cursor: crosshair;
  }

  /* --- SCROLL INDICATOR STYLES --- */
  .scroll-indicator {
    position: absolute;
    bottom: 3vh;
    left: 50%;
    transform: translateX(-50%);
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 15px; /* Increased gap slightly for the taller arrow */
    z-index: 60;
  }

  .scroll-text {
    font-family: 'Deuterium-Light', sans-serif;
    color: white;
    font-size: 14px; /* Slightly larger than previous 0.75rem */
    letter-spacing: 0.2em;
    text-transform: uppercase;
  }

  .scroll-arrow {
    width: 20px;
    height: 60px; /* Taller dimension for the long arrow style */
    overflow: visible;
    animation: bounce 2s infinite ease-in-out;
  }

  .arrow-line, .arrow-head {
    stroke: white; 
    stroke-width: 2; 
    fill: none;
  }

  @keyframes bounce {
    0%, 20%, 50%, 80%, 100% { transform: translateY(0); }
    40% { transform: translateY(-10px); }
    60% { transform: translateY(-5px); }
  }

  /* --- SCROLL FLOW --- */
  .scroll-flow {
    position: relative;
    width: 100vw;
    z-index: 1;
    padding-top: 100vh; 
  }

  .video-wrapper {
    position: relative;
    width: 100vw;
    height: 100vh;
    background-color: #000;
    overflow: hidden;
  }

  .bg-iframe {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%) scale(1.02);
    pointer-events: none;
    background-color: #000;
    
    height: 100%;
    width: 177.77vh; 
    filter: grayscale(100%);
  }

  @media (min-aspect-ratio: 16/9) {
    .bg-iframe {
      width: 100%;
      height: 56.25vw;
    }
  }

  .noise-overlay {
    position: absolute;
    top: 0; left: 0; width: 100%; height: 100%;
    pointer-events: none; z-index: 10;
    mix-blend-mode: overlay;
    image-rendering: pixelated;
    transform-origin: center;
  }

  /* --- CENTER TRIGGER CONTAINER --- */
  .center-trigger {
    position: absolute;
    top: 50%; left: 50%;
    transform: translate(-50%, -50%);
    z-index: 20;
    
    width: 80vw;
    height: auto;
    
    background: transparent;
    border: none;
    padding: 0;
    cursor: crosshair; 
    display: block; 
  }

  /* --- TRIGGER IMAGE STYLES --- */
  .trigger-img {
    width: 100%;
    height: auto;
    display: block;
    box-shadow: 0 10px 30px rgba(0,0,0,0.5);

    /* Base state: Grayscale */
    filter: grayscale(100%); 
    transition: filter 0.5s ease, transform 0.5s cubic-bezier(0.25, 1, 0.5, 1);
  }

  /* Hover on container -> Affects Image */
  .center-trigger:hover .trigger-img {
      filter: grayscale(0%);
      transform: scale(1.02);
  }

  /* --- TRIANGLE PLAY BUTTON OVERLAY STYLES --- */
  .play-button-overlay {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%); 
    
    width: 120px;
    height: 80px;
    
    display: flex;
    justify-content: center;
    align-items: center;
    pointer-events: none; 

    transition: transform 0.3s cubic-bezier(0.25, 1, 0.5, 1), filter 0.3s ease;
  }

  /* Hover on container -> Affects Play Button */
  .center-trigger:hover .play-button-overlay {
      transform: translate(-50%, -50%) scale(1.15);
      filter: brightness(0.9);
  }

  /* Click (Active) on container -> Affects Play Button */
  .center-trigger:active .play-button-overlay {
      transform: translate(-50%, -50%) scale(1.08);
      filter: brightness(0.8);
  }

  .play-svg {
    width: 100%;
    height: 100%;
    fill: rgba(255, 255, 255, 0.95);
    filter: drop-shadow(0 0 15px rgba(0,0,0,0.5));
  }

  /* --- CUSTOM CURSOR --- */
  .cursor-play {
    position: fixed;
    top: 0; left: 0;
    z-index: 200;
    pointer-events: none;
    
    font-family: 'Deuterium-Ultra', sans-serif;
    font-size: 24px;
    letter-spacing: 2px;
    color: white;
    
    margin-left: 15px; 
    margin-top: 15px;
    
    mix-blend-mode: difference;
    text-shadow: 0 0 10px rgba(0,0,0,0.5);
  }
   
  /* --- OVERLAY FIXED --- */
  .overlay {
    position: fixed; 
    top: 0; 
    left: 0; 
    width: 100vw; 
    height: 100vh;
    height: 100svh;
    
    background-color: #000;
    z-index: 9999;
    
    display: flex;
    justify-content: center;
    align-items: center;
  }

  .video-embed-wrapper {
    aspect-ratio: 1.89 / 1;
    width: min(80vw, 70vh * 1.89); 
    position: relative;
    overflow: hidden; 
    background: black; 
  }

  .vimeo-embed {
    position: absolute;
    top: 50%;
    left: 50%;
    width: 100%;
    height: 100%;
    transform: translate(-50%, -50%) scale(1.01);
  }

  .nav-btn {
    position: absolute; background: transparent; 
    border: none; padding: 20px;
    cursor: pointer; z-index: 10000; 
    display: flex; align-items: center; gap: 15px;
    transition: opacity 0.3s;
  }
   
  .nav-btn.close-btn { top: 20px; right: 30px; }
   
  .btn-text {
    font-family: 'Deuterium-Ultra', sans-serif;
    font-size: 24px; color: white; letter-spacing: 2px;
  }

  .close-svg { width: 25px; height: 25px; overflow: visible; }
  .close-svg line {
    stroke: white; stroke-width: 2; fill: none;
    transition: transform 0.3s cubic-bezier(0.25, 1, 0.5, 1); 
  }
   
  .close-btn:hover .close-svg { transform: rotate(90deg); }

  @media (max-width: 768px) {
    .btn-text { font-size: 16px; }
    .close-svg { width: 20px; height: 20px; }
    .center-trigger { width: 80vw; } 
    .play-button-overlay { width: 90px; height: 60px; }
    .video-embed-wrapper { width: 95%; }
  }
</style>