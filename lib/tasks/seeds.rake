namespace :db do
  desc 'Load the seed data from db/seeds_2010.rb'
  task :seed_2010 => :environment do
    seed_file = File.join(Rails.root, 'db', 'seeds_2010.rb')
    load(seed_file) if File.exist?(seed_file)
  end
end
