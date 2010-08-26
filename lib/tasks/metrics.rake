namespace :metrics do
  task :reek do
    puts '*' * 10
    puts 'REEK'
    system('reek app/models/*.rb')
  end

  task :roodi do
    puts '*' * 10
    puts 'ROODI'
    system('roodi "app/models/*.rb"')
  end

  task :flay do
    puts '*' * 10
    puts 'FLAY'
    system('flay app/models/*.rb')
  end

  task :all => [:reek, :roodi, :flay]
end

