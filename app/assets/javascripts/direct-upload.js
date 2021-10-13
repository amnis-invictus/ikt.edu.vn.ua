(function () {
  var template = '<div id="direct-upload-:id:" class="direct-upload direct-upload--pending">' +
    '<div id="direct-upload-progress-:id:" class="direct-upload__progress" style="width: 0%"></div>' +
    '<span class="direct-upload__filename"></span></div>';

  addEventListener('direct-upload:initialize', function (event) {
    event.target.insertAdjacentHTML('beforebegin', template.replace(/:id:/g, event.detail.id));
    event.target.previousElementSibling.querySelector('.direct-upload__filename').textContent = event.detail.file.name;
  });

  addEventListener('direct-upload:start', function (event) {
    var element = document.getElementById('direct-upload-' + event.detail.id);
    element.classList.remove('direct-upload--pending');
  });

  addEventListener('direct-upload:progress', function (event) {
    var progressElement = document.getElementById('direct-upload-progress-' + event.detail.id);
    progressElement.style.width = event.detail.progress + '%';
  });

  addEventListener('direct-upload:error', function (event) {
    event.preventDefault();
    var element = document.getElementById('direct-upload-' + event.detail.id);
    element.classList.add('direct-upload--error');
    element.setAttribute('title', event.detail.error);
  });

  addEventListener('direct-upload:end', function (event) {
    var element = document.getElementById('direct-upload-' + event.detail.id);
    element.classList.add('direct-upload--complete');
  });
})();
