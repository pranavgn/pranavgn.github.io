import gsap from "gsap";

// gsap code
document.addEventListener("DOMContentLoaded", (event) => {
      let c = document.getElementsByClassName('collapse');
      let u = document.getElementsByClassName('uncollapse');
      let tlTitle = gsap.timeline();
      tlTitle.to(c[0], )
      tlTitle.to(c[1], )
});

// function collapse() {
//       let collapse = document.getElementsByClassName('collapse');
//       let uncollapse = document.getElementsByClassName('uncollapse');
//       Array.from(collapse).forEach(el => {
//             el.style.maxWidth = 0;
//             el.style.maxHeight = 0;
//       });
//       Array.from(uncollapse).forEach(el =>{
//             el.style.maxWidth = '100%';
//             el.style.maxHeight = '100%';
//       });
// }

let test = document.getElementById('test');
test.addEventListener('click', collapse);