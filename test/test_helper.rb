# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "update_by_case"
require "minitest/autorun"
require_relative "../models/test_model"
require "byebug"
require_relative "../support/database_configuration"
require 'minitest/hooks/test'
require 'active_record'

DatabaseConfiguration.establish_connection

class GemTest < Minitest::Test
  include Minitest::Hooks

  def around
    ActiveRecord::Base.transaction do
      super
      raise ActiveRecord::Rollback
    end
  end

end
