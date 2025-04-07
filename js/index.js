function crtp(rem) {    
      return rem * parseFloat(getComputedStyle(document.documentElement).fontSize);
}

function cvwtp(vw) {
      return vw * (document.documentElement.clientWidth)/100
}

function cvhtp(vh) {
      return vh * (document.documentElement.clientHeight)/100
}

gsap.registerPlugin(ScrollTrigger);
gsap.registerPlugin(ScrollToPlugin);

function scrollToId(id) {
      gsap.to(window, {
            duration: 0.8,
            scrollTo: "#" + id,
            autoKill: true,
            ease: "power2.in"
      });
}


let pinElements = gsap.utils.toArray(".transition-shrink");
pinElements.forEach( (card, i) => {
      gsap.to(card, {
            scale: 0.33,
            // opacity: 0.4,
            ease: "power1.in",
            scrollTrigger: {
                  trigger: card,
                  scrub: true,
                  pin: true,
                  // markers: true,
                  invalidateOnRefresh: true,
                  start: 'top top+=' + crtp(2 + i * 2),
                  end: "+=" + (cvhtp(300 - 75 * i))
            }
      })
});

pinElements.forEach( (card, i) => {
      gsap.to(card, {
            duration: 0.5,
            scrollTo: {
                  y: "#work",
                  offsetY: cvhtp(75 * i)
            }
      })
});

pinElements.forEach( (card, i) => {
      gsap.to(card, {
            opacity: 0.4,
            ease: "power1.in",
            scrollTrigger: {
                  trigger: card,
                  scrub: true,
                  // markers: true,
                  invalidateOnRefresh: true,
                  start: 'top top+=' + crtp(2 + i * 2),
                  end: "+=" + cvwtp(80)
            }
      })
});

gsap.to("#anim-wrap", {
      x: (-1 * window.innerWidth * 1.5),
      ease: "none",
      scrollTrigger: {
            trigger: "#about",
            pin: true,
            pinSpacing: "margin",
            anticipatePin: 1,
            scrub: true,
            invalidateOnRefresh: true,
            start: "top top",
            end: "+=" + window.innerWidth * 2.6
      }
});


fitty('#nametag1', {
      maxSize: 490,
});
fitty('#nametag2', {
      maxSize: 750,
});
fitty('#abtt1', {
      maxSize: 500
});
fitty('#abtt2', {
      maxSize: 450,
});
fitty('#abtt3', {
      maxSize: 450,
});
fitty('#ac1', {
      maxSize: 450,
});
