const completeBtn = document.querySelector('.complete-btn');
const completeForm = document.querySelector('.complete-form');

function showCompleteForm() {
  completeForm.classList.toggle('hidden');
}

completeBtn.addEventListener('click', showCompleteForm);