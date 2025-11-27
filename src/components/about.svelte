<script>
  import { onMount } from 'svelte';
  
  let sectionElement;
  let word1, word2, word3;
  let bioElement;

  onMount(async () => {
    const { gsap } = await import('gsap');
    const { ScrollTrigger } = await import('gsap/ScrollTrigger');
    gsap.registerPlugin(ScrollTrigger);

    await new Promise(resolve => requestAnimationFrame(resolve));

    // Initial Setup: Force GSAP values to match CSS start states
    gsap.set(word1, { height: '85vh', zIndex: 3 });
    gsap.set(word2, { height: '57vh', zIndex: 2 });
    gsap.set(word3, { height: '28vh', zIndex: 1 });
    gsap.set(bioElement, { autoAlpha: 0 });

    const tl = gsap.timeline({
      scrollTrigger: {
        trigger: sectionElement,
        // Pin when top of section is 15% down the viewport (15vh offset)
        start: "top 15%", 
        end: "+=350%", 
        scrub: true,
        pin: true,
        anticipatePin: 1
      }
    });

    // STEP 1: FILMMAKER Shrinks (85vh -> 28vh)
    tl.to(word1, { height: '28vh', ease: 'none' });

    // STEP 2: WRITER Enters (Scrolls in from bottom / Grows 0vh -> 57vh)
    tl.to(word2, { height: '26vh', ease: 'none' });

    // STEP 3: WRITER Shrinks (57vh -> 28vh)
    // tl.to(word2, { height: '28vh', ease: 'none' });

    // STEP 4: DESIGNER Enters (Grows 0vh -> 29vh)
    tl.to(word3, { height: '29vh', ease: 'none' });

    // STEP 5: ALL Shrink to final stack (Total ~42.5vh)
    tl.to([word1, word2, word3], { height: '15vh', ease: 'none' });

    // STEP 6: Reveal Bio
    tl.to(bioElement, { autoAlpha: 1, duration: 0.5 });
  });
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

<section class="about-section" bind:this={sectionElement}>
  <div class="stack-container">
    
    <div class="word-block initial-full" bind:this={word1}>
      <svg width="100%" height="100%" viewBox="0 0 200 25" preserveAspectRatio="none">
        <text 
          x="0" y="50%" dominant-baseline="central" text-anchor="start"
          textLength="200" lengthAdjust="spacingAndGlyphs" class="word-text"
        >
          FILMMAKER
        </text>
      </svg>
    </div>

    <div class="word-block hidden-start" bind:this={word2}>
      <svg width="100%" height="100%" viewBox="0 0 200 25" preserveAspectRatio="none">
        <text 
          x="0" y="50%" dominant-baseline="central" text-anchor="start"
          textLength="200" lengthAdjust="spacingAndGlyphs" class="word-text"
        >
          WRITER
        </text>
      </svg>
    </div>

    <div class="word-block hidden-start" bind:this={word3}>
      <svg width="100%" height="100%" viewBox="0 0 200 25" preserveAspectRatio="none">
        <text 
          x="0" y="50%" dominant-baseline="central" text-anchor="start"
          textLength="200" lengthAdjust="spacingAndGlyphs" class="word-text"
        >
          DESIGNER
        </text>
      </svg>
    </div>

  </div>

  <div class="bio-container" bind:this={bioElement}>
    <p class="bio-text">
        Pushing boundaries every day.<br>
        Crafting visual narratives across mediums.<br>
        Obsessed with noise, light, and time.
    </p>
  </div>
</section>

<style>
  /* Container for the pinned section */
  .about-section {
    position: relative;
    width: 100vw;
    height: 100vh; 
    background-color: black;
    overflow: hidden;
    display: flex;
    flex-direction: column;
    justify-content: flex-start; 
  }

  .stack-container {
    width: 100%;
    display: flex;
    flex-direction: column;
    /* Ensure container doesn't overflow horizontally causing scrollbars */
    overflow: hidden; 
  }

  .word-block {
    width: 98%; /* Prevent right-edge clipping on specific viewports */
    margin: 0 auto; /* Center the block */
    will-change: height;
    line-height: 0;
    overflow: visible; /* CRITICAL: Allows SVG text to overhang slightly without clipping */
  }

  /* CSS Initial States to prevent Animation Glitches */
  .initial-full {
    height: 85vh;
  }
  .hidden-start {
    height: 0;
  }

  .word-block svg {
    display: block;
    width: 100%;
    height: 100%;
    overflow: visible; /* Double insurance for clipping */
  }

  .word-text {
    font-family: 'Deuterium-Ultra', sans-serif;
    fill: white;
    font-size: 30px; 
  }

  /* Bio Styling */
  .bio-container {
    width: 100%;
    padding: 20px;
    box-sizing: border-box;
    display: flex;
    justify-content: center; 
    align-items: flex-start;
  }

  .bio-text {
    font-family: 'Deuterium-Light', sans-serif;
    color: white;
    font-size: 14px;
    letter-spacing: 0.2em;
    text-transform: uppercase;
    line-height: 1.6;
    margin: 0;
    opacity: 0.8;
    text-align: center;
  }
</style>