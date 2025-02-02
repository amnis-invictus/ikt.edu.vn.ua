$(document).on('click', '.table-form input[type=button]', function () {
  this.value = '⏳';
  this.disabled = true;
  const row = this.closest('.table-form');
  const data = new FormData();
  row.querySelectorAll('input[name], select[name]').forEach((input) => { data.append(input.name, input.value); });
  Rails.ajax({ url: row.dataset.url, type: 'PATCH', data });
});

$(document).on('input', '.table-form', function () {
  this.classList.remove('error');
  this.classList.add('changed');
  const button = this.querySelector('input[type=button]');
  button.classList.remove('hidden');
  button.value = '💾';
  button.disabled = false;
});
