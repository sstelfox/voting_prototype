begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError
  puts 'RSpec isn\'t available to the rake environment'
end

begin
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new(:rubocop) do |task|
    task.formatters = %w(simple offenses)
    task.fail_on_error = false
    task.options = %w(--format html --out doc/rubocop.html)
  end
rescue LoadError
  puts 'Rubocop isn\'t available to the rake environment'
end

begin
  require 'yard'
  YARD::Rake::YardocTask.new(:docs)
rescue LoadError
  puts 'Yardoc isn\'t available to the rake environment'
end

task :default do
  Rake::Task[:docs].invoke     if Rake::Task.task_defined?(:docs)
  Rake::Task[:rubocop].invoke  if Rake::Task.task_defined?(:rubocop)
  Rake::Task[:spec].invoke     if Rake::Task.task_defined?(:spec)
end

task 'environment' do
  begin
    require 'fabrication'
    require 'faker'
  rescue LoadError
    puts 'Model mocks aren\'t available to the rake environment'
  end

  require './voting'
end

desc 'Run all the tests'
task test: [:environment] do
  require 'spec/test_helper'
end

# This will print all of the configured routes for the sinatra application in
# the order that the route was first specified. All of the methods will be
# combined together and it will format the output into neat columns. Very
# useful for debugging when an incorrect route is being hit.
desc 'List all of the routes configured'
task routes: [:environment] do
  require 'sinatra/decompile'

  rl = Voting::App.routes.each_with_object(Hash.new([])) do |verb, route_list|
    verb[1].each do |route|
      route_list[route[0].source] += [verb[0]]
    end
  end

  column_length = rl.values.map { |v| v.join(', ').length }.max
  rl.each_pair do |route, methods|
    decompiled_route = Sinatra::Decompile.decompile(route)
    printf("%-#{column_length}s  %s\n", methods.sort.join(', '), decompiled_route)
  end
end

desc 'Run a console with the application loaded'
task console: [:environment] do
  require 'pry'
  pry
end

namespace :db do
  desc 'Upgrade or initialize the database'
  task migrate: [:environment] do
    DataMapper.auto_upgrade!
  end

  desc 'Blow away the current database and start from scratch'
  task reset: [:environment] do
    DataMapper.auto_migrate!
    Rake::Task['db:seed'].execute
  end

  desc 'Seed the database with initial required data'
  task seed: [:environment, 'db:migrate'] do
    require './config/seed'
  end
end
