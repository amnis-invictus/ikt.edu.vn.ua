(function () {
  var template = '<div id="direct-upload-:id:" class="direct-upload direct-upload--pending">' +
    '<div id="direct-upload-progress-:id:" class="direct-upload__progress" style="width: 0%"></div>' +
    '<span class="direct-upload__filename"></span></div>';

  addEventListener('direct-upload:initialize', function (event) {
    logger.info('Direct upload initialized for file "%s" with id %s', event.detail.file.name, event.detail.id);
    event.target.insertAdjacentHTML('beforebegin', template.replace(/:id:/g, event.detail.id));
    event.target.previousElementSibling.querySelector('.direct-upload__filename').textContent = event.detail.file.name;
  });

  addEventListener('direct-upload:start', function (event) {
    logger.info('Direct upload started for file "%s" with id %s', event.detail.file.name, event.detail.id);
    var element = document.getElementById('direct-upload-' + event.detail.id);
    element.classList.remove('direct-upload--pending');
  });

  addEventListener('direct-upload:progress', function (event) {
    logger.info('Direct upload progress for file "%s" with id %s: %d%%', event.detail.file.name, event.detail.id, event.detail.progress);
    var progressElement = document.getElementById('direct-upload-progress-' + event.detail.id);
    progressElement.style.width = event.detail.progress + '%';
  });

  addEventListener('direct-upload:error', function (event) {
    logger.info('Direct upload error for file "%s" with id %s: %s', event.detail.file.name, event.detail.id, event.detail.error);
    event.preventDefault();
    var element = document.getElementById('direct-upload-' + event.detail.id);
    element.classList.add('direct-upload--error');
    element.setAttribute('title', event.detail.error);
  });

  addEventListener('direct-upload:end', function (event) {
    logger.info('Direct upload finished for file "%s" with id %s', event.detail.file.name, event.detail.id);
    var element = document.getElementById('direct-upload-' + event.detail.id);
    element.classList.add('direct-upload--complete');
  });

  addEventListener('direct-uploads:start', function () {
    logger.info('All direct uploads started');
  });

  addEventListener('direct-uploads:end', function () {
    logger.info('All direct uploads finished');
  });
})();
