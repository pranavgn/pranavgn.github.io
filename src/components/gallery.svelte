<script>
  import { spring } from 'svelte/motion';
  import { fade, fly } from 'svelte/transition';
  import { imageDetails } from '../data/galleryDetails.js';
  import { onMount } from 'svelte';

  // --- HELPER: Extract Vimeo ID from URL ---
  function getVimeoId(url) {
    if (!url) return null;
    const match = url.match(/vimeo\.com\/(\d+)/);
    return match ? match[1] : url; 
  }

  // --- 1. PROGRAMMATIC DATA LOADING ---
  const imageModules = import.meta.glob('/public/*/*.{jpg,jpeg,png,webp}', { eager: true, as: 'url' });
  
  const targetYears = ["2025", "2024", "2023", "2022", "2021", "2020", "2019"];

  const galleryData = targetYears.map(year => {
      const items = Object.keys(imageModules)
          .filter(path => path.includes(`/${year}/`))
          .map(path => {
              const src = path.replace('/public', ''); 
              const filename = path.split('/').pop().split('.')[0];
              const customData = imageDetails[src];
              const title = customData?.title || filename.replace(/[-_]/g, ' ');
              const caption = customData?.caption || `A piece from the ${year} collection.`;
              const link = customData?.link || null;
              
              return {
                  id: src, src, title, caption, link 
              };
          });

      return { year, items };
  }).filter(group => group.items.length > 0);

  // --- STATE ---
  let activeImage = null; 
  let hoverImage = null;  

  // --- GSAP ANIMATION ---
  let yearHeaders = []; 

  onMount(async () => {
    const { gsap } = await import('gsap');
    const { ScrollTrigger } = await import('gsap/ScrollTrigger');
    gsap.registerPlugin(ScrollTrigger);

    await new Promise(resolve => requestAnimationFrame(resolve));

   yearHeaders.forEach((header) => {
      if (!header) return;

      gsap.to(header, {
        height: '5vh', 
        ease: 'power3.out',
        scrollTrigger: {
          trigger: header,
          start: "top 15%", 
          end: "+=80%",
          scrub: true,
          pin: true,
          pinSpacing: false,
          onLeave: () => gsap.set(header, { height: '5vh' }),
          onEnterBack: () => gsap.set(header, { height: '5vh' })
        }
      });
    });
  });

  // --- CURSOR LOGIC ---
  let coords = spring({ x: 0, y: 0 }, { stiffness: 0.1, damping: 0.25 });
  function handleMouseMove(e) { coords.set({ x: e.clientX, y: e.clientY }); }

  // --- NAVIGATION LOGIC ---
  const flatGallery = galleryData.flatMap(group => group.items);
  let activeIndex = -1; 
  
  function openOverlay(item) {
    activeImage = item;
    activeIndex = flatGallery.findIndex(i => i.id === item.id);
    document.body.style.overflow = 'hidden';
  }

  function closeOverlay() {
    activeImage = null;
    document.body.style.overflow = '';
  }

  function navigate(direction) {
    const newIndex = activeIndex + direction;
    if (newIndex >= 0 && newIndex < flatGallery.length) {
        activeImage = flatGallery[newIndex];
        activeIndex = newIndex;
    }
  }

  const nextImage = () => navigate(1);
  const prevImage = () => navigate(-1);
  
  $: isPrevDisabled = activeIndex <= 0;
  $: isNextDisabled = activeIndex >= flatGallery.length - 1;
</script>

<svelte:window on:mousemove={handleMouseMove} />

{#if hoverImage}
  <div 
    class="cursor-preview" 
    style="transform: translate({$coords.x}px, {$coords.y}px)"
  >
    <img src={hoverImage} alt="preview" />
  </div>
{/if}

<section class="gallery">
  {#each galleryData as group, i}
    <div 
      class="year-header" 
      bind:this={yearHeaders[i]}
    >
      <svg width="100%" height="100%" viewBox="0 0 200 35" preserveAspectRatio="none">
        <text 
          x="0" y="50%" dominant-baseline="central" text-anchor="start"
          textLength="200" lengthAdjust="spacingAndGlyphs" class="year-text"
        >
          {group.year}
        </text>
      </svg>
    </div>

    <div class="floating-container">
      {#each group.items as item}
        <div 
          class="image-item"
          on:mouseenter={() => hoverImage = item.src}
          on:mouseleave={() => hoverImage = null}
          on:click={() => openOverlay(item)}
        >
          <img src={item.src} alt={item.title} class="item-thumb" />
        </div>
      {/each}
    </div>
  {/each}
</section>

{#if activeImage}
  <div class="overlay" transition:fade={{duration: 200}}>
    
    <button class="nav-btn close-btn" on:click={closeOverlay}>
      <span class="btn-text">CLOSE</span>
      <svg class="close-svg" viewBox="0 0 20 20">
        <line x1="1" y1="1" x2="19" y2="19" stroke="white" stroke-width="2" />
        <line x1="19" y1="1" x2="1" y2="19" stroke="white" stroke-width="2" />
      </svg>
    </button>

    <button class="nav-btn prev" on:click={prevImage} disabled={isPrevDisabled}>
      <svg class="arrow-svg" viewBox="0 0 60 20" preserveAspectRatio="none">
        <line class="arrow-line" x1="60" y1="10" x2="2" y2="10" />
        <polyline class="arrow-head" points="10,2 2,10 10,18" />
      </svg>
      <span class="btn-text">PREV</span>
    </button>

    <button class="nav-btn next" on:click={nextImage} disabled={isNextDisabled}>
      <span class="btn-text">NEXT</span>
      <svg class="arrow-svg" viewBox="0 0 60 20" preserveAspectRatio="none">
        <line class="arrow-line" x1="0" y1="10" x2="58" y2="10" />
        <polyline class="arrow-head" points="50,2 58,10 50,18" />
      </svg>
    </button>
    
    <div class="overlay-content">
      {#if activeImage.link}
        <div class="video-wrapper">
          <iframe 
            src="{getVimeoId(activeImage.link)}" 
            frameborder="0" 
            allow="autoplay; fullscreen; picture-in-picture" 
            allowfullscreen
            class="vimeo-embed"
            title={activeImage.title}
          ></iframe>
        </div>
      {:else}
        <img src={activeImage.src} alt={activeImage.title} />
      {/if}
    </div>

    <div class="caption-bar" transition:fly={{y: 50, duration: 300}}>
      <p><strong>{activeImage.title}</strong> — {activeImage.caption}</p>
    </div>
  </div>
{/if}

<style>
  /* --- MAIN GALLERY STYLES --- */
  .gallery {
    background: black;
    color: white;
    padding-bottom: 100px;
    width: 100%;
    overflow-x: hidden; 
  }

  /* --- YEAR HEADER (ANIMATED) --- */
  .year-header {
    width: 100%; 
    height: 50vh; 
    background: black;
    margin: 0; padding: 0; 
    line-height: 0;
    display: block; 
    position: relative;
    z-index: 40; 
    will-change: height;
    overflow: hidden;
  }
  
  /* UPDATED: Ensure SVG is block to remove inline gap */
  .year-header svg {
    display: block;
    width: 100%;
    height: 100%;
  }

  .year-text {
    font-family: 'Deuterium-Ultra', sans-serif;
    font-size: 30px; fill: white;
  }

  /* --- FLOATING CONTAINER --- */
  .floating-container {
    display: flex; flex-wrap: wrap; 
    justify-content: center; 
    /* UPDATED: Changed from center to flex-start to pull items to top edge */
    align-items: flex-start;
    padding: 0 20px 60px 20px; 
    /* UPDATED: Negative margin to kill sub-pixel gaps */
    margin-top: -1px; 
    width: 100%; box-sizing: border-box;
    position: relative;
    z-index: 10;
    background: black;
    gap: 60px; /* Only applies between items, not top edge */
  }

  .image-item {
    cursor: crosshair; 
    width: auto; max-width: 400px; 
    position: relative; transition: transform 0.2s;
  }
  
  .image-item:hover { transform: scale(1.02); }

  .item-thumb {
    display: block; width: 100%; height: auto; 
    max-height: 50vh; object-fit: contain; 
    filter: grayscale(100%); transition: filter 0.3s, opacity 0.3s;
  }

  .image-item:hover .item-thumb { filter: grayscale(0%); opacity: 0.2; }

  /* --- CURSOR PREVIEW --- */
  .cursor-preview {
    position: fixed; top: 0; left: 0;
    width: 300px; pointer-events: none; z-index: 50;
    margin-left: -150px; margin-top: -150px;
  }
  .cursor-preview img { width: 100%; display: block; }

  /* --- OVERLAY --- */
  .overlay {
    position: fixed; top: 0; left: 0; width: 100%; height: 100%;
    background: rgba(0,0,0,0.95); z-index: 100;
    display: flex; flex-direction: column;
    justify-content: center; align-items: center;
  }

  .overlay-content img {
    max-width: 90vw; max-height: 80vh; object-fit: contain;
  }

  /* --- VIMEO EMBED STYLES --- */
  .video-wrapper {
    aspect-ratio: 1.89 / 1;
    width: min(80vw, 70vh * 1.89); 
    position: relative;
    overflow: hidden; 
    background: black; 
    /* box-shadow: 0 0 30px rgba(0,0,0,0.5); */
  }

  .vimeo-embed {
    position: absolute;
    top: 50%;
    left: 50%;
    width: 100%;
    height: 100%;
    transform: translate(-50%, -50%) scale(1.01);
  }

  @media (max-width: 768px) {
    .video-wrapper { width: 95vw; }
  }

  .caption-bar {
    position: absolute; bottom: 0; width: 100%;
    padding: 20px; background: black; color: white;
    text-align: center; border-top: 1px solid #333;
  }

  /* --- BUTTONS --- */
  .nav-btn {
    position: absolute; background: transparent; 
    border: none; padding: 20px;
    cursor: pointer; z-index: 110;
    display: flex; align-items: center; gap: 15px;
    transition: opacity 0.3s;
  }

  .nav-btn.prev { top: 50%; transform: translateY(-50%); left: 30px; }
  .nav-btn.next { top: 50%; transform: translateY(-50%); right: 30px; }
  .nav-btn.close-btn { top: 20px; right: 30px; }

  .btn-text {
    font-family: 'Deuterium-Ultra', sans-serif;
    font-size: 24px; color: white; letter-spacing: 2px;
  }

  .arrow-svg, .close-svg { overflow: visible; }
  .arrow-svg { width: 60px; height: 20px; }
  .close-svg { width: 25px; height: 25px; }

  .arrow-line, .arrow-head, .close-svg line {
    stroke: white; stroke-width: 2; fill: none;
    transition: transform 0.3s cubic-bezier(0.25, 1, 0.5, 1); 
  }

  .prev:hover:not(:disabled) .arrow-svg { transform: translateX(-10px); }
  .next:hover:not(:disabled) .arrow-svg { transform: translateX(10px); }
  .close-btn:hover .close-svg { transform: rotate(90deg); }

  .nav-btn:disabled { opacity: 0.2; cursor: not-allowed; }

  @media (max-width: 768px) {
    .btn-text { font-size: 16px; }
    .arrow-svg { width: 40px; }
    .close-svg { width: 20px; height: 20px; }
  }
</style>