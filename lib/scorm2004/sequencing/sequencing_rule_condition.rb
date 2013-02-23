require 'scorm2004/sequencing'

module Scorm2004
  module Sequencing
    class SequencingRuleCondition
      module Description
        VOCABULARY = [
          'Satisfied',
          'Objective Status Known',
          'Objective Measure Known',
          'Objective Measure Greater Than',
          'Objective Measure Less Than',
          'Completed',
          'Activity Progress Known',
          'Attempted',
          'Attempt Limit Exceeded',
          'Always'
        ]

        def rule_condition
          cond = @d['condition'] or raise 'Could not find Sequencing Rule Condition'
          VOCABULARY.find { |v|
            v.delete(' ').downcase == cond.downcase
          } or raise "invalid Sequencing Rule Condition: #{cond}"
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
      end

      include Description

      # @param description [Hash] a hash object that represents a <ruleCondition> element
      def initialize(description)
        @d = description
      end

      def evaluate(activity)
        klass = self.class.const_get(rule_condition.delete(' ') + 'Evaluator')
        result = klass.new.call(activity)
        if result.nil?
          nil
        elsif operator == 'Not'
          !result
        else
          result
        end
      end
    end
  end
end
