set :branch, :main

set :deploy_to, '/opt/ai/ikt.codelabs.site'

set :rails_env, :production

server 'ikt.codelabs.site:10017', user: 'arch-user', roles: %i[app web db]
