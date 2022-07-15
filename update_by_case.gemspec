# frozen_string_literal: true

require_relative "lib/update_by_case/version"

Gem::Specification.new do |spec|
  spec.name = "update_by_case"
  spec.version = UpdateByCase::VERSION
  spec.authors = ["Camilo Vargas A"]
  spec.email = ["vargas.antiguay@gmail.com"]

  spec.summary = "Update multiple records based on case values on a single database hit"
  spec.description = "This gem adds to ActiveRecord a method update_by_case that allows you to update multiple records based on case values on a single database hit."
  spec.homepage = "https://github.com/camilova/activerecord-update-by-case"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.4.5"
  spec.files = [
    "lib/update_by_case.rb",
    "lib/update_by_case/version.rb",
    "lib/update_by_case/utils.rb",
  ]
  spec.require_paths = ["lib"]
  spec.add_dependency "activerecord", ">= 4.0.0"
  spec.add_dependency "pg"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'pg'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'railties'
  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'minitest-hooks'
end
