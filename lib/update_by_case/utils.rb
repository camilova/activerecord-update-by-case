require 'arel'

module UpdateByCase
  class Utils
    WHERE_OPTION = 'where'.freeze

    class << self

      def build_case_statement(model, attribute_name, key_attribute, cases)
        case_statement = Arel::Nodes::Case.new
        arel_table = model.arel_table
        cases.each do |xcase|
          condition = arel_table[key_attribute].eq(xcase.first)
          case_statement.when(condition).then(xcase.second)
        end
        case_statement.else(arel_table[attribute_name])
      end
      
    end

  end
end
