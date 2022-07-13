require 'yaml'
require 'erb'
require 'active_record'

class DatabaseConfiguration

  def self.load
    root = File.expand_path('../..', __FILE__)
    YAML.load(ERB.new(IO.read(File.join(root, 'config/database.yml'))).result)
  end

  def self.establish_connection
    ActiveRecord::Base.configurations = load
    ActiveRecord::Base.establish_connection((ENV['ENV'] || 'development').to_sym)
  end

end
