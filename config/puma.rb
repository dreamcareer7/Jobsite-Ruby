#   #!/usr/bin/env puma

# directory '/home/deploy/muqawiloon/current'
# rackup "/home/deploy/muqawiloon/current/config.ru"
# environment 'production'

# pidfile "/home/deploy/muqawiloon/shared/tmp/pids/puma.pid"
# state_path "/home/deploy/muqawiloon/shared/tmp/pids/puma.state"
# stdout_redirect '/home/deploy/muqawiloon/shared/log/puma_error.log', '/home/deploy/muqawiloon/shared/log/puma_access.log', true


# min_threads = Integer(ENV["MIN_THREADS"] || 1)
# max_threads = Integer(ENV["MAX_THREADS"] || 16)

# threads min_threads, max_threads

# bind 'unix:///home/deploy/muqawiloon/shared/tmp/sockets/puma.sock'

# workers 0



# prune_bundler


# on_restart do
#   puts 'Refreshing Gemfile'
#   ENV["BUNDLE_GEMFILE"] = "/home/deploy/muqawiloon/current/Gemfile"
# end






threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
threads threads_count, threads_count

port        ENV.fetch("PORT") { 3000 }

environment ENV.fetch("RAILS_ENV") { "development" }

plugin :tmp_restart