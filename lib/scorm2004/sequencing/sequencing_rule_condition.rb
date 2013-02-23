require 'scorm2004/sequencing'

module Scorm2004
  module Sequencing
    class SequencingRuleCondition
      module Description
        def rule_condition
          normalize(@d['condition'])
        end
        alias :to_s :rule_condition

        def rule_condition_referenced_objective
          @d['referenced_objective']
        end
        alias :referenced_objective :rule_condition_referenced_objective

        def rule_condition_measure_threshold
          @d['measure_threshold']
        end
        alias :measure_threshold :rule_condition_measure_threshold

        def rule_condition_operator
          ('not' == @d['operator']) ? 'Not' : 'NO-OP'
        end
        alias :operator :rule_condition_operator

        private

        def normalize(str)
          str.to_s.scan(/[A-Z]?[a-z]+/).map(&:capitalize).join(' ')
        end
      end

      include Description

      # @param description [Hash] a hash object that represents a <ruleCondition> element
      def initialize(description)
        @d = description
      end
    end
  end
end
