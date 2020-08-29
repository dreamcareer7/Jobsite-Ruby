lock '3.10.0'

set :application, 'muqawiloon'
set :repo_url, 'git@gitlab.com:neat-soft/muqawiloon-v1-prod.git'
set :branch, ENV["REVISION"] || ENV["BRANCH_NAME"] || :master
set :deploy_to, '/home/deploy/muqawiloon'
set :pty, false
set :linked_files, %w(config/application.yml config/secrets/muqawiloon-gsa.json)
set :linked_dirs, %w(log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads)
set :keep_releases, 5
set :rbenv_ruby, '2.3.1'

set :puma_rackup, -> { File.join(current_path, 'config.ru') }
set :puma_state, "#{shared_path}/tmp/pids/puma.state"
set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
set :puma_bind, "unix://#{shared_path}/tmp/sockets/puma.sock"
set :puma_conf, "#{shared_path}/puma.rb"
set :puma_access_log, "#{shared_path}/log/puma_error.log"
set :puma_error_log, "#{shared_path}/log/puma_access.log"
set :puma_role, :app
set :puma_env, fetch(:rack_env, fetch(:rails_env, 'production'))
set :puma_threads, 1
set :puma_workers, 1
set :puma_worker_timeout, nil
set :puma_init_active_record, true
set :puma_preload_app, true

set :sidekiq_config, 'config/sidekiq.yml'
set :sidekiq_log, '/dev/null'
set :sidekiq_processes, 1

set :ssh_options, { :forward_agent => true }

set :clockwork_file, "lib/clock.rb"

namespace :bower do
  desc 'Install bower'
  task :install do
    on roles(:web) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'bower:install CI=true'
        end
      end
    end
  end
end
before 'deploy:compile_assets', 'bower:install'

require 'appsignal/capistrano'
