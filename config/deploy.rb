set :application, 'IKT'

set :repo_url, 'https://github.com/amnis-invictus/ikt.edu.vn.ua.git'

set :default_env, { path: '$HOME/.rbenv/shims:$PATH' }

append :linked_files, '.env', 'config/master.key'

append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system', 'storage'

namespace :deploy do
  after :finishing, 'application:restart'
  after :finishing, 'nginx:reload'
  after :finishing, 'bundler:clean'
end
