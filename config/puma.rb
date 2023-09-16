# Puma can serve each request in a thread from an internal thread pool.
# The `threads` method setting takes two numbers: a minimum and maximum.
# Any libraries that use thread pools should be configured to match
# the maximum value specified for Puma. Default is set to 5 threads for minimum
# and maximum; this matches the default thread size of Active Record.
#
min_threads_count = ENV.fetch 'RAILS_MIN_THREADS', 1
max_threads_count = ENV.fetch 'RAILS_MAX_THREADS', 5
threads min_threads_count, max_threads_count

rails_env = ENV.fetch 'RAILS_ENV', 'development'
worker_timeout 3600 if rails_env == 'development'
environment rails_env

if %w[production staging].include? rails_env
  bind ENV.fetch 'SOCKET'
else
  port ENV.fetch 'PORT', 3000
end

pidfile ENV.fetch 'PIDFILE', 'tmp/pids/server.pid'

if %w[production staging].include? rails_env
  # Specifies the number of `workers` to boot in clustered mode.
  # Workers are forked web server processes. If using threads and workers together
  # the concurrency of the application would be max `threads` * `workers`.
  # Workers do not work on JRuby or Windows (both of which do not support
  # processes).
  #
  workers ENV.fetch 'WEB_CONCURRENCY', 2

  # Use the `preload_app!` method when specifying a `workers` number.
  # This directive tells Puma to first boot the application and load code
  # before forking the application. This takes advantage of Copy On Write
  # process behavior so workers use less memory.
  #
  preload_app!

  on_worker_boot do
    ActiveSupport.on_load(:active_record) { ActiveRecord::Base.establish_connection }
    RedisLockManager::POOL.reload &:quit
  end
end

# Allow puma to be restarted by `rails restart` command.
plugin :tmp_restart
