<script>
      import Hero from './components/hero.svelte';
      import Loader from './components/loader.svelte';
      import Gallery from './components/gallery.svelte';
      import About from './components/about.svelte';
      import Contact from './components/contact.svelte';

  let loading = true;
  const myImages = ['/img1.jpg', '/img2.jpg', '/poster.jpg']; // List your heavy assets
</script>

<main>
      <Loader />
      <Hero />
      <Gallery />
      <About />
      <Contact />
</main>

<style>
</style>
