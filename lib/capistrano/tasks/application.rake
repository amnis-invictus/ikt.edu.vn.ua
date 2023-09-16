namespace :application do
  desc 'Start application'
  task :start do
    on roles(:app), in: :sequence, wait: 5 do
      within current_path do
        execute 'sudo systemctl start ikt.codelabs.site'
      end
    end
  end

  desc 'Stop application'
  task :stop do
    on roles(:app), in: :sequence, wait: 5 do
      within current_path do
        execute 'sudo systemctl stop ikt.codelabs.site'
      end
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      within current_path do
        execute 'sudo systemctl restart ikt.codelabs.site'
      end
    end
  end
end
