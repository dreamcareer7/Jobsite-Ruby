# namespace :paperclip do
#   desc "build missing paperclip styles"
#   task :build_missing_styles do
#     on roles(:app) do
#       within release_path do
#         with rails_env: fetch(:rails_env) do
#           execute :rake, "paperclip:refresh:missing_styles"
#         end
#       end
#     end
#   end
# end
# 
# after("deploy:compile_assets", "paperclip:build_missing_styles")
