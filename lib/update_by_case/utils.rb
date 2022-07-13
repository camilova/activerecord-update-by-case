module UpdateByCase
  class Utils
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
          sql_key_attribute_value = key_attribute_value
          if key_attribute_value.is_a?(String) || key_attribute_value.is_a?(Symbol)
            sql_key_attribute_value = "'#{key_attribute_value}'"
          end
          case_sql_fragment += "WHEN #{sql_key_attribute_value} THEN #{value}#{SEPARATOR}"
        end
        sql_type = sql_type(model, attribute_name)
        case_sql_fragment += "ELSE #{attribute_name} END)::#{sql_type}"
      end
      
    end

  end
end
