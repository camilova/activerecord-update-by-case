# frozen_string_literal: true

require_relative "update_by_case/version"
require "active_record"

module UpdateByCase
  extend ::ActiveSupport::Concern

  class UpdateByCaseUtils
    WHERE_OPTION = 'where'.freeze
    SEPARATOR = (ENV['ENV']&.downcase == 'development' ? "\n" : " ").freeze

    class << self

      def separate_operator
        ",#{SEPARATOR}"
      end

      def sql_value(attribute_value)
        attribute_value.nil?? 'NULL' : "'#{attribute_value}'"
      end

      def sql_type(model, attribute_name)
        model.columns.find { |c| c.name.to_s == attribute_name.to_s }.sql_type
      end

      def build_case_sql_fragment(model, attribute_name, key_attribute, attribute_cases)
        case_sql_fragment = "#{attribute_name}=(CASE #{key_attribute}#{SEPARATOR}"
        attribute_cases.each do |key_attribute_value, attribute_value|
          value = sql_value(attribute_value)
          case_sql_fragment += "WHEN #{key_attribute_value} THEN #{value}#{SEPARATOR}"
        end
        sql_type = sql_type(model, attribute_name)
        case_sql_fragment += "ELSE #{attribute_name} END)::#{sql_type}"
      end
      
    end
  end

  included do

    def self.update_by_case!(cases)
      case_sql_fragment = ""
      cases.each do |attribute_name, attribute_cases|
        next if attribute_name&.to_s == UpdateByCaseUtils::WHERE_OPTION
        if attribute_cases.is_a?(Hash) && attribute_cases.size == 1 && 
          attribute_cases.first.second.is_a?(Hash) then
          case_sql_fragment += UpdateByCaseUtils.separate_operator unless case_sql_fragment.empty?
          case_sql_fragment += UpdateByCaseUtils.build_case_sql_fragment(
            self,
            attribute_name, 
            attribute_cases.first.first, 
            attribute_cases.first.second,
          )
        elsif attribute_cases.is_a?(Hash) && attribute_cases.size.positive?
          case_sql_fragment += UpdateByCaseUtils.separate_operator unless case_sql_fragment.empty?
          case_sql_fragment += UpdateByCaseUtils.build_case_sql_fragment(
            self,
            attribute_name, 
            primary_key, 
            attribute_cases
          )
        elsif ! attribute_cases.is_a?(Hash)
          # Assume attribute_cases is only one value for all cases
          case_sql_fragment += UpdateByCaseUtils.separate_operator unless case_sql_fragment.empty?
          value = UpdateByCaseUtils.sql_value(attribute_cases)
          sql_type = UpdateByCaseUtils.sql_type(self, attribute_name)
          case_sql_fragment += "#{attribute_name}=#{value}::#{sql_type}#{UpdateByCaseUtils::SEPARATOR}"
        end
      end
      instance = self
      instance = where(cases[:where]) if cases[:where].present?
      instance.update_all(case_sql_fragment)
    end

    def update_by_case
      update_by_case! rescue false
    end

  end

end

ActiveRecord::Base.send(:include, UpdateByCase)
