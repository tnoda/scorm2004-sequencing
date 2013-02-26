require 'scorm2004/sequencing'
require 'scorm2004/sequencing/sequencing_rule_condition'
require 'scorm2004/sequencing/sequencing_rule_check_subprocess'

module Scorm2004
  module Sequencing
    class SequencingRule
      module CheckSubprocess
        # Invoke Sequencing Rule Check Subprocess [UP.2.1]
        def check(activity)
          SequencingRuleCheckSubprocess.new(self).call(activity)
        end
      end

      module Description
        def condition_combination
          ('any' == @d['rule_conditions'].to_h['condition_combination']) ? 'Any' :'All'
        end

        def rule_conditions
          @d['rule_conditions'].to_h['rule_conditions'].to_a.map do |rule_condition|
            SequencingRuleCondition.new(rule_condition)
          end
        end
        alias :conditions :rule_conditions

        def rule_action
          normalize(@d['rule_action'].to_h['action'])
        end
        alias :action :rule_action

        private

        def normalize(str)
          str.to_s.scan(/[A-Z]?[a-z]+/).map(&:capitalize).join(' ')
        end
      end

      include Description
      include CheckSubprocess

      def initialize(description)
        @d = description
      end
    end
  end
end
