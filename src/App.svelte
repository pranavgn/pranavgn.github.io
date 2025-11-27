<script>
  import { onMount, tick } from 'svelte';
  import Hero from './components/hero.svelte';
  import Loader from './components/loader.svelte';
  import Gallery from './components/gallery.svelte';
  import About from './components/about.svelte';
  import Contact from './components/contact.svelte';

  let loading = true;

  onMount(async () => {
    // 1. DYNAMIC IMPORTS
    const { gsap } = await import('gsap');
    const { ScrollTrigger } = await import('gsap/ScrollTrigger');
    const { ScrollToPlugin } = await import('gsap/ScrollToPlugin');
    gsap.registerPlugin(ScrollTrigger, ScrollToPlugin);

    // 2. THE RESET LOGIC
    // Stop browser from automatically scrolling to the last known position
    if ('scrollRestoration' in history) {
      history.scrollRestoration = 'manual';
    }
    
    // Force the window to the very top immediately
    window.scrollTo(0, 0);
  });

  async function handleLoaderDone() {
    loading = false;
    
    // Wait for the DOM to update (Loader removal)
    await tick(); 

    // Import GSAP to refresh calculations
    const { ScrollTrigger } = await import('gsap/ScrollTrigger');
    
    // Recalculate start/end points now that the loader is gone.
    // We do NOT scroll to any hash here. We just refresh the math.
    ScrollTrigger.refresh();
  }
</script>

<main>
  <Loader on:done={handleLoaderDone} />
  
  <div class="content-wrapper">
      <Hero />
      <section id="work">
            <Gallery />
      </section>
      <section id="about">
            <About />
      </section>
      <section id="contact">
            <Contact />
      </section>
  </div>
</main>

<style>
  /* Ensure smooth scrolling is handled by GSAP, not CSS */
  :global(html) {
    scroll-behavior: auto !important;
  }
</style>