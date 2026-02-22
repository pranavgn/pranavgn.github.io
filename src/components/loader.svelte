<script>
  import { onMount, createEventDispatcher } from 'svelte';
  import { fade } from 'svelte/transition';

  const dispatch = createEventDispatcher();
  
  let progress = 0;
  let visible = true;

  const galleryModules = import.meta.glob('/public/*/*.{webp}', { eager: true, as: 'url' });
  
  const galleryImages = Object.keys(galleryModules).map(path => {
      return path.replace('/public', ''); 
  });

  const staticAssets = [
    '/Title.svg',
    '/2025/20251.webp'
  ];

  const allImages = [...galleryImages, ...staticAssets];

  onMount(async () => {
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
    setTimeout(() => {
      visible = false;
      dispatch('done'); 
    }, 500);
  }
</script>

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
    background: black;
    z-index: 9999;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
  }

  .progress-bar-container {
    width: 300px;
    height: 2px;
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
