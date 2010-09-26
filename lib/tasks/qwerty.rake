namespace :qwerty do
  task :config do    
    # Rails.root can not be used since loading the environment requires settings.yml to exist
    base_path = File.join(File.dirname(__FILE__), '..', '..') 
    %w(settings database sitemap).each do | name |
      path = File.join(base_path, 'config')
      source = File.join(path, name + '.example.yml')
      dest = File.join(path, name + '.yml')
      unless File.exists? dest
        FileUtils.cp(source, dest)
        puts 'Copied ' + dest
      end
    end
    # TODO: make database.yml using folder name (Rails.root.split('/).last ?)
  end
  
  task :bootstrap => [:environment] do
    unless File.exists? File.join(Rails.root, 'config', 'database.yml')
      raise 'database.yml is missing, try: rake qwerty:config'
    end

    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke    
    Rake::Task['qwerty:core:seed'].invoke    
    Rake::Task['qwerty:cms:build_site'].invoke    
    puts 'Hint: Use qwerty:cms:seed id=all to add some seed data'
  end
end