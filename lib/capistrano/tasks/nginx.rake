namespace :nginx do
  desc 'Reload nginx'
  task :reload do
    on roles(:app), in: :sequence, wait: 5 do
      within current_path do
        execute 'sudo systemctl reload nginx'
      end
    end
  end
end
