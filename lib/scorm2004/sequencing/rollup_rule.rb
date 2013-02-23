require 'scorm2004/sequencing'
require 'scorm2004/sequencing/rollup_rule_description'
require 'scorm2004/sequencing/evaluate_rollup_conditions_subprocess'

module Scorm2004
  module Sequencing
    class RollupRule
      include RollupRuleDescription

      def initialize(rule)
        @rule = rule
      end

      def evaluate(child)
        EvaluateRollupConditionsSubprocess.new(self).call(child)
      end
    end
  end
end
