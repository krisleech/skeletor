namespace :xrefresh do
  task :configure => [:environment] do
    config_file = ENV['config_file'] || File.expand_path(File.join('~', '.xrefresh-server.yml'))
    root_path = ENV['path'] || RAILS_ROOT
    config = YAML::load(IO.read(config_file))
    config['paths'] << root_path unless config['paths'].include? root_path
    File.open(config_file, 'w') {|f| f.write(config.to_yaml) }
  end

  task :run do
    system 'xrefresh-server'
  end
end