namespace :qwerty do  
  namespace :core do
    task :install => [:environment, :copy_files] do
        
      # todo: insert routes, insert environment code, copy public files
        
      Rake::Task['db:drop'].invoke
      Rake::Task['db:create'].invoke
      Rake::Task['db:migrate'].invoke
        
    end
    
    
    task :seed => [:environment] do
      u=User.create(
        :first_name => 'Admin',
        :last_name => 'Person',
        :email => 'admin@example.com',
        :password => 'admin',
        :password_confirmation => 'admin'
      )
      u.roles = ['admin']
      u.save

      p = ActiveSupport::SecureRandom.hex(16)
      u=User.create(
        :first_name => 'Anonymous',
        :last_name => 'Person',
        :email => 'anonymous@example.com',
        :password => p,
        :password_confirmation => p
      )
      u.save
    end



    task :copy_files => [:environment] do
      plugins = %w(core cms)
      plugins.each do |plugin|
        plugin_path = File.join(RAILS_ROOT, 'vendor', 'plugins', plugin)
    
        folders = ['db/migrate']

        folders.each do |folder|
          puts 'copying from ' + folder
          source_path = plugin_path + '/' + folder
          destination_path = RAILS_ROOT + '/' + folder         
          if File.exists? source_path
            FileUtils.mkdir_p destination_path unless File.exists? destination_path           
            Dir.glob(source_path + '/*') do |source_file|
              unless File.exists? destination_path + '/' + File.basename(source_file)
                `cp #{source_file} #{destination_path}`
                puts 'file copied'
              else
                puts 'file already exists'
              end
            end      
          end  
        end
      end
    end
  end
end
