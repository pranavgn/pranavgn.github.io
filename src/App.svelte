<script>
  import { onMount, onDestroy, tick } from 'svelte';
  import Hero from './components/hero.svelte';
  import Loader from './components/loader.svelte';
  import Gallery from './components/gallery.svelte';
  import About from './components/about.svelte';
  import Contact from './components/contact.svelte';
  import { gsap } from 'gsap';
  import { ScrollTrigger } from 'gsap/ScrollTrigger';

  let loading = true;
  let scrollTriggerInstances = [];

  onMount(() => {
    window.scrollTo(0, 0);
  });

  async function handleLoaderDone() {
    loading = false;
    
    await tick();
    await new Promise(resolve => requestAnimationFrame(resolve));
    await new Promise(resolve => requestAnimationFrame(resolve));
    
    ScrollTrigger.refresh();
  }

  onDestroy(() => {
    scrollTriggerInstances.forEach(st => st.kill());
    scrollTriggerInstances = [];
    ScrollTrigger.getAll().forEach(st => st.kill());
  });
</script>

<main>
  {#if loading}
    <Loader on:done={handleLoaderDone} />
  {/if}
  
  <div class="content-wrapper" class:hidden={loading}>
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
  :global(html) {
    scroll-behavior: auto !important;
  }
  
  .content-wrapper {
    opacity: 1;
    transition: opacity 0.3s ease;
  }
  
  .content-wrapper.hidden {
    opacity: 0;
  }
</style>
