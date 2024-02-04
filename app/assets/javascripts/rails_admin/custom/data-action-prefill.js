$(document).on('click', '[data-action="prefill"]', function (e) {
  const $prefillTarget = $($(this).data('target'));
  const $eventTarget = $(e.target);
  $prefillTarget.val($eventTarget.text());
});
