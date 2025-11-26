<script>
  import { onMount, createEventDispatcher } from 'svelte';
  import { fade } from 'svelte/transition';

  const dispatch = createEventDispatcher();
  
  let progress = 0;
  let visible = true;

  // --- 1. AUTO-DETECT GALLERY IMAGES ---
  // Using the same glob pattern as gallery.svelte to find all project assets
  const galleryModules = import.meta.glob('/public/*/*.{jpg,jpeg,png,webp}', { eager: true, as: 'url' });
  
  // Clean paths to match how they are served (removing '/public' prefix)
  const galleryImages = Object.keys(galleryModules).map(path => {
      return path.replace('/public', ''); 
  });

  // --- 2. MANUAL STATIC ASSETS ---
  // Explicitly add assets from Hero/About that aren't caught by the glob
  const staticAssets = [
    '/Title.svg',
    '/2025/20251.png'
  ];

  // Combine all assets into a single load queue
  const allImages = [...galleryImages, ...staticAssets];

  onMount(async () => {
    // Immediate completion if no images found
    if (allImages.length === 0) {
      progress = 100;
      completeLoading();
      return;
    }

    let loadedCount = 0;

    const loadPromises = allImages.map((src) => {
      return new Promise((resolve) => {
        const img = new Image();
        img.src = src;
        img.onload = () => {
            loadedCount++;
            progress = Math.round((loadedCount / allImages.length) * 100);
            resolve();
        };
        img.onerror = () => {
            // Resolve anyway so one broken image doesn't hang the loader
            loadedCount++; 
            progress = Math.round((loadedCount / allImages.length) * 100);
            resolve();
        };
      });
    });

    await Promise.all(loadPromises);
    completeLoading();
  });

  function completeLoading() {
    // Brief delay to ensure user sees 100%
    setTimeout(() => {
      visible = false;
      dispatch('done'); 
    }, 500);
  }
</script>

<svelte:head>
  <style>
    @font-face {
      font-family: 'Deuterium-Ultra';
      src: url('/fonts/Deuterium-Variable-Thin.ttf'); 
      font-weight: 900;
      font-style: normal;
    }
  </style>
</svelte:head>

{#if visible}
  <div class="loader-overlay" out:fade={{ duration: 500 }}>
    <div class="progress-bar-container">
      <div class="progress-bar" style="width: {progress}%"></div>
    </div>
    <p class="progress-text">{progress}%</p>
  </div>
{/if}

<style>
  .loader-overlay {
    position: fixed;
    top: 0; left: 0; width: 100%; height: 100%;
    background: black; /* Updated to match site theme */
    z-index: 9999;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
  }

  .progress-bar-container {
    width: 300px;
    height: 2px; /* Thinner, minimal styling */
    background: #333;
    margin-bottom: 15px;
  }

  .progress-bar {
    height: 100%;
    background: white;
    transition: width 0.1s linear;
  }

  .progress-text {
    font-family: 'Deuterium-Light', sans-serif;
    color: white;
    font-size: 14px;
    letter-spacing: 0.1em;
    margin: 0;
  }
</style>