# frozen_string_literal: true

require_relative "update_by_case/version"
require_relative "update_by_case/utils"
require "active_record"

module UpdateByCase
  extend ::ActiveSupport::Concern

  included do

    class << self

      def update_by_case!(cases)
        case_sql_fragment = ""
        cases.each do |attribute_name, attribute_cases|
          next if attribute_name&.to_s == Utils::WHERE_OPTION
          if attribute_cases.is_a?(Hash) && attribute_cases.size == 1 && 
            attribute_cases.first.second.is_a?(Hash) then
            case_sql_fragment += Utils.separate_operator unless case_sql_fragment.empty?
            case_sql_fragment += Utils.build_case_sql_fragment(
              self,
              attribute_name, 
              attribute_cases.first.first, 
              attribute_cases.first.second,
            )
          elsif attribute_cases.is_a?(Hash) && attribute_cases.size.positive?
            case_sql_fragment += Utils.separate_operator unless case_sql_fragment.empty?
            case_sql_fragment += Utils.build_case_sql_fragment(
              self,
              attribute_name, 
              primary_key, 
              attribute_cases
            )
          elsif ! attribute_cases.is_a?(Hash)
            # Assume attribute_cases is only one value for all cases
            case_sql_fragment += Utils.separate_operator unless case_sql_fragment.empty?
            value = Utils.sql_value(attribute_cases)
            sql_type = Utils.sql_type(self, attribute_name)
            case_sql_fragment += "#{attribute_name}=#{value}::#{sql_type}#{Utils::SEPARATOR}"
          end
        end
        instance = self
        instance = where(cases[:where]) if cases[:where].present?
        instance.update_all(case_sql_fragment)
      end

      def update_by_case(cases)
        update_by_case!(cases) rescue false
      end

    end

  end

end

ActiveRecord::Base.send(:include, UpdateByCase)
