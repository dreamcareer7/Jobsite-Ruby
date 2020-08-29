namespace :auto_complete do
  desc "Auto complete services and businesses"
  task index: :environment do
    AutoComplete.index_target_terms
  end
end
