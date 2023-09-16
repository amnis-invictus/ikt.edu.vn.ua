def service_name = fetch(:rails_env) == :staging ? 'stage-ikt.codelabs.site' : 'ikt.codelabs.site'

namespace :application do
  desc 'Start application'
  task :start do
    on roles(:app), in: :sequence, wait: 5 do
      within current_path do
        execute :sudo, :systemctl, :start, service_name
      end
    end
  end

  desc 'Stop application'
  task :stop do
    on roles(:app), in: :sequence, wait: 5 do
      within current_path do
        execute :sudo, :systemctl, :stop, service_name
      end
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      within current_path do
        execute :sudo, :systemctl, :restart, service_name
      end
    end
  end
end
