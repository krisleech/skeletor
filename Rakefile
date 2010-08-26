# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'

require 'yard'


YARD::Rake::YardocTask.new do |t|
  t.files   = ['app/**/*.rb']
end

require 'reek/rake/task'

Reek::Rake::Task.new do |t|
  t.fail_on_error = false
end




task :roodi do
  system('roodi "app/models/*.rb"')
end

task :flay do
  system('flay app/models/*.rb')
end

task :metrics => [:reek, :roodi, :flay]