# frozen_string_literal: true

require "bundler/gem_tasks"
require "rake/testtask"
require './support/active_record_rake_tasks'
require_relative "./support/database_configuration"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/test_*.rb"]
end

task :prepare_test_database do
  ENV['ENV'] = 'test'
  Rake::Task['db:drop'].invoke
  Rake::Task['db:create'].invoke
  Rake::Task['db:migrate'].invoke
  Rake::Task['db:seed'].invoke
  DatabaseConfiguration.establish_connection
end

task :test => :prepare_test_database

task :environment
