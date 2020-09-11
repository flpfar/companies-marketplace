const navBtn = document.querySelector('.nav-btn');
const navMenu = document.querySelector('.nav-menu');

navBtn.addEventListener('click', () => {
  navMenu.classList.toggle('hidden');
});