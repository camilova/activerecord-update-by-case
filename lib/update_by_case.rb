# frozen_string_literal: true

require_relative "update_by_case/version"
require_relative "update_by_case/utils"
require "active_record"
require "byebug" if ENV['ENV']&.downcase == 'development'

module UpdateByCase
  extend ::ActiveSupport::Concern

  included do

    class << self

      def update_by_case!(cases)
        update_hash = {}
        cases.each do |attribute_name, attribute_cases|
          next if attribute_name&.to_s == Utils::WHERE_OPTION
          if attribute_cases.is_a?(Hash) && attribute_cases.size == 1 &&
            attribute_cases.first&.second&.is_a?(Hash) then
            cases = attribute_cases.first.second
            key_attribute = attribute_cases.first.first
            case_statement = Utils.build_case_statement(self, attribute_name, key_attribute, cases)
          elsif attribute_cases.is_a?(Hash) && attribute_cases.size.positive?
            key_attribute = primary_key
            case_statement = Utils.build_case_statement(self, attribute_name, key_attribute, attribute_cases)
          elsif ! attribute_cases.is_a?(Hash)
            # Assume attribute_cases is only one value for all cases
            case_statement = attribute_cases
          else
            raise 'invalid provided cases hash'
          end
          update_hash[attribute_name] = case_statement
        end
        where(cases[:where] || {}).update_all(update_hash)
      end

      def update_by_case(cases)
        update_by_case!(cases) rescue false
      end

    end

  end

end

ActiveRecord::Base.send(:include, UpdateByCase)
