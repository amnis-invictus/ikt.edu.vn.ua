set :branch, :main

set :deploy_to, '/opt/ai/stage-ikt.codelabs.site'

set :rails_env, :staging

append :linked_files, 'config/credentials/staging.key'

server 'stage-ikt.codelabs.site:10016', user: 'arch-user', roles: %i[app web db]
