<script>
  import { onMount, onDestroy } from 'svelte';
  import { gsap } from 'gsap';
  import { ScrollTrigger } from 'gsap/ScrollTrigger';
  
  gsap.registerPlugin(ScrollTrigger);
  
  let sectionElement;
  let word1, word2, word3;
  let bioElement;
  let scrollTriggerInstance = null;

  onMount(async () => {
    await new Promise(resolve => requestAnimationFrame(resolve));

    const navHeight = 15;
    const availableHeight = 85;
    const equalHeight = availableHeight / 3;
    const minFinalHeight = 8;
    
    gsap.set(word1, { height: `${availableHeight}vh`, top: `${navHeight}vh` });
    gsap.set(word2, { height: '0vh', top: `${navHeight + availableHeight}vh` });
    gsap.set(word3, { height: '0vh', top: `${navHeight + availableHeight}vh` });
    gsap.set(bioElement, { autoAlpha: 0 });

    scrollTriggerInstance = ScrollTrigger.create({
      trigger: sectionElement,
      start: "top 15vh",
      end: "+=600%",
      scrub: 0.5,
      pin: true,
      anticipatePin: 1,
      onUpdate: (self) => {
        const p = self.progress;
        
        let h1 = 0, h2 = 0, h3 = 0;
        const bioStart = 0.70;
        const bioEnd = 0.92;
        
        if (p < 0.20) {
          const p1 = p / 0.20;
          h1 = availableHeight - p1 * (availableHeight - equalHeight);
          h2 = p1 * equalHeight;
          h3 = p1 * equalHeight;
        } else if (p < bioStart) {
          const p2 = (p - 0.20) / (bioStart - 0.20);
          const currentHeight = equalHeight - p2 * (equalHeight - minFinalHeight * 1.8);
          h1 = currentHeight;
          h2 = currentHeight;
          h3 = currentHeight;
        } else {
          const p3 = (p - bioStart) / (1 - bioStart);
          const currentHeight = minFinalHeight * 1.8 - p3 * (minFinalHeight * 1.8 - minFinalHeight);
          h1 = currentHeight;
          h2 = currentHeight;
          h3 = currentHeight;
        }
        
        const minH = 3;
        h1 = Math.max(minH, h1);
        h2 = Math.max(minH, h2);
        h3 = Math.max(minH, h3);
        
        const top1 = navHeight;
        const top2 = navHeight + h1;
        const top3 = navHeight + h1 + h2;
        
        gsap.set(word1, { height: `${h1}vh`, top: `${top1}vh` });
        gsap.set(word2, { height: `${h2}vh`, top: `${top2}vh` });
        gsap.set(word3, { height: `${h3}vh`, top: `${top3}vh` });
        
        let bioProgress = 0;
        if (p >= bioStart) {
          bioProgress = Math.min(1, (p - bioStart) / (bioEnd - bioStart));
        }
        gsap.set(bioElement, { autoAlpha: bioProgress });
        
        const totalWordsHeight = h1 + h2 + h3;
        const bioTop = navHeight + totalWordsHeight + 1;
        gsap.set(bioElement, { top: `${bioTop}vh` });
      }
    });
  });

  onDestroy(() => {
    if (scrollTriggerInstance) {
      scrollTriggerInstance.kill();
      scrollTriggerInstance = null;
    }
  });
</script>

<section class="about-section" bind:this={sectionElement}>
  <div class="stack-container">
    
    <div class="word-block" bind:this={word1}>
      <svg width="100%" height="100%" viewBox="0 0 200 25" preserveAspectRatio="none">
        <text 
          x="0" y="50%" dominant-baseline="central" text-anchor="start"
          textLength="200" lengthAdjust="spacingAndGlyphs" class="word-text"
        >
          FILMMAKER
        </text>
      </svg>
    </div>

    <div class="word-block" bind:this={word2}>
      <svg width="100%" height="100%" viewBox="0 0 200 25" preserveAspectRatio="none">
        <text 
          x="0" y="50%" dominant-baseline="central" text-anchor="start"
          textLength="200" lengthAdjust="spacingAndGlyphs" class="word-text"
        >
          WRITER
        </text>
      </svg>
    </div>

    <div class="word-block" bind:this={word3}>
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
    height: 100vh;
    position: relative;
    overflow: hidden;
  }

  .word-block {
    position: absolute;
    width: 98%;
    left: 1%;
    will-change: height, top;
    line-height: 0;
    overflow: hidden;
  }

  .word-block svg {
    display: block;
    width: 100%;
    height: 100%;
  }

  .word-text {
    font-family: 'Deuterium-Ultra', sans-serif;
    fill: white;
    font-size: 30px; 
  }

  .bio-container {
    position: absolute;
    width: 100%;
    padding: 20px;
    box-sizing: border-box;
    display: flex;
    justify-content: center; 
    align-items: flex-start;
    z-index: 10;
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
