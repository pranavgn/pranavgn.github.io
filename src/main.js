import { mount } from 'svelte';
import './app.css';
import App from './App.svelte';
import { gsap } from 'gsap';
import { ScrollTrigger } from 'gsap/ScrollTrigger';
import { ScrollToPlugin } from 'gsap/ScrollToPlugin';

gsap.registerPlugin(ScrollTrigger, ScrollToPlugin);
gsap.config({ force3D: true, nullTargetWarn: false });
ScrollTrigger.config({ limitCallbacks: true, ignoreMobileResize: true });

if ('scrollRestoration' in history) {
  history.scrollRestoration = 'manual';
}

mount(App, { target: document.getElementById('app') });

export { gsap, ScrollTrigger, ScrollToPlugin };
