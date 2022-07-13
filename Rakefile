# frozen_string_literal: true

require "bundler/gem_tasks"
require "rake/testtask"
require './support/active_record_rake_tasks'

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/test_*.rb"]
end

task :prepare_test_database do
  ENV['ENV'] = 'test'
  %w(drop create migrate seed).each do |task|
    system("ENV=test rake db:#{task}")
  end
end

task :test => :prepare_test_database

task :environment
