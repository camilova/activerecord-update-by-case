# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "update_by_case"
require "minitest/autorun"
require_relative "../models/test_model"
require "byebug"
require_relative "../support/database_configuration"

DatabaseConfiguration.establish_connection
