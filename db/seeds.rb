Dir[File.join(Rails.root, 'db', 'seeds', '*.rb')].sort.each { |seed| puts "creating #{ seed.split('/').last.split('_').drop(1).join('').split('.').first }...\n"; load seed }
