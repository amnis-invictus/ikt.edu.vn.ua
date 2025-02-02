function showCustomAlert(message, type) {
  const alertContainer = document.createElement('div');
  alertContainer.classList.add('alert', 'alert__dynamic', `alert__${type}`);
  alertContainer.textContent = message;
  document.body.appendChild(alertContainer);
  setTimeout(() => { alertContainer.style.opacity = '1'; }, 0);
  setTimeout(() => { alertContainer.style.opacity = '0'; }, 2000);
  setTimeout(() => { document.body.removeChild(alertContainer); }, 2500);
}
