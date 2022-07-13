# Add the ability to run db:create/migrate/drop etc
require 'active_record'
require_relative './database_configuration'
include ActiveRecord::Tasks

root = File.expand_path('../..', __FILE__)
DatabaseTasks.root = root
DatabaseTasks.db_dir = File.join(root, 'db')
DatabaseTasks.migrations_paths = [File.join(root, 'db/migrate')]
DatabaseTasks.database_configuration = DatabaseConfiguration.load

# The SeedLoader is Optional, if you don't want/need seeds you can skip setting it
class SeedLoader
  def initialize(seed_file)
    @seed_file = seed_file
  end

  def load_seed
    load @seed_file if File.exist?(@seed_file)
  end
end

DatabaseTasks.seed_loader = SeedLoader.new(File.join(root, 'db/seeds.rb'))

DatabaseTasks.env = ENV['ENV'] || 'development'

DatabaseConfiguration.establish_connection

load 'active_record/railties/databases.rake'
