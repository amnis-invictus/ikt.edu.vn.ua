Sentry.init do |config|
  # Send events synchronously.
  config.background_worker_threads = 0

  # Sentry uses breadcrumbs to create a trail of
  # events that happened prior to an issue.
  config.breadcrumbs_logger = %i[active_support_logger http_logger]

  # The maximum number of breadcrumbs the SDK would hold.
  config.max_breadcrumbs = 2_500

  # Set traces_sample_rate to 1.0 to capture 100%
  # of transactions for performance monitoring.
  config.traces_sample_rate = 1.0
end
