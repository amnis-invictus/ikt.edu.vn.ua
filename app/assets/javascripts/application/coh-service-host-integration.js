$(document).ready(function () {
  var $coh = $('#coh');
  if ($coh.length !== 1) return;

  var STATUS_IN_PROGRESS = 'Автентифікація ⏳';
  var STATUS_OK = 'Автентифікація ✅';
  var STATUS_ERROR = 'Автентифікація ⚠️';

  var cohConfig = $coh.data('config');
  var cohURL = $coh.data('url');

  function fetchCOHData(onSuccess, onError) {
    $coh.text(STATUS_IN_PROGRESS);
    $.ajax({
      url: cohURL,
      type: 'GET',
      dataType: 'json',
      timeout: 5000,
      success: function (data) {
        var isValid = typeof data === 'object' && data !== null &&
          typeof data.CohGuid === 'string' && typeof data.Otp === 'string';
        if (isValid) {
          logger.info('Fetch COH data OK', data);
          $coh.text(STATUS_OK);
          onSuccess && onSuccess(data);
        } else {
          logger.error('Fetch COH data ERROR: invalid format', data);
          $coh.text(STATUS_ERROR);
          onError && onError();
        };
      },
      error: function (xhr, textStatus, errorThrown) {
        logger.error('Fetch COH data ERROR:', textStatus, errorThrown, xhr);
        $coh.text(STATUS_ERROR);
        onError && onError();
      }
    });
  }

  $(document).on('submit', 'form[data-coh]', function (e) {
    logger.info('COH integration: form submit intercepted');

    var form = e.target;
    var $form = $(form);

    if ($form.is('[data-direct-uploads-processing]')) {
      logger.info('COH integration: direct uploads in progress, returning');
      return;
    }

    var $cohGUIDInput = $form.find('input[name="coh_guid"]');
    var $cohOTPInput = $form.find('input[name="coh_otp"]');
    var $submitButton = $form.find('input[type="submit"]');
    var $errorContainer = $form.find('[data-target="error"]');

    $submitButton.prop('disabled', true);
    $errorContainer.hide();
    e.preventDefault();

    fetchCOHData(function (data) {
      $cohGUIDInput.val(data.CohGuid);
      $cohOTPInput.val(data.Otp);
      logger.info('COH integration: submitting form with COH data');
      form.submit();
    }, function () {
      if (cohConfig === 'forced') {
        logger.info('COH integration: not submitting form');
        $submitButton.prop('disabled', false);
        $errorContainer.show();
      } else {
        logger.info('COH integration: submitting form without COH data');
        form.submit();
      }
    });

    return false;
  });

  fetchCOHData();
});
