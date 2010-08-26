namespace :qwerty do
  task :bootstrap => [:environment] do
    # TODO: create database.yml using folder name for database name
    unless File.exists? File.join(Rails.root, 'config', 'database.yml')
      raise 'database.yml is missing, copy/modify config/database.yml.example'
    end

    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke    
    Rake::Task['qwerty:core:seed'].invoke    
    Rake::Task['qwerty:cms:build_site'].invoke    
    puts 'Hint: Use qwerty:cms:seed id=all to add some seed data'
  end
end