require 'scorm2004/sequencing'

module Scorm2004
  module Sequencing
    class RollupCondition
      class SatisfiedEvaluator
        def call(child)
          ro = child.rolled_up_objective
          ro && ro.progress_status && ro.satisfied_status
        end
      end

      class ObjectiveStatusKnownEvaluator
        def call(child)
          ro = child.rolled_up_objective
          ro && ro.progress_status
        end
      end

      class ObjectiveMeasureKnownEvaluator
        def call(child)
          ro = child.rolled_up_objective
          ro && ro.measure_status
        end
      end

      class ActivityProgressKnownEvaluator
        def call(child)
          child.attempt_progress_status
        end
      end

      class AttemptedEvaluator
        def call(child)
          child.activity_attempt_count > 0
        end
      end

      class AttemptLimitExceededEvaluator
        def call(child)
          child.instance_eval do
            attempt_progress_status && limit_condition_attempt_limit_control &&
              (activity_attempt_count >= limit_condition_attempt_limit)
          end
        end
      end

      class NeverEvaluator
        def call(*args)
          false
        end
      end

      VOCABULARY = [
        'Never', 'Satisfied',
        'Objective Status Known', 'Objective Measure Known',
        'Completed', 'Activity Progress Known',
        'Attempted', 'Attempt Limit Exceeded'
      ]

      def initialize(rollup_condition = {})
        @rollup_condition = rollup_condition
      end

      # @return [String] the value of Rollup Rule Condition
      def rule_condition
        cond = @rollup_condition['condition']
        if cond
          VOCABULARY.find { |v| v.delete(' ').downcase == cond.downcase }
        else
          'Never'
        end
      end

      # @return [String] the value of Rollup Condition Operator
      def rule_condition_operator
        (@rollup_condition['operator'] == 'not') ? 'Not' : 'NO-OP'
      end

      # Evaluate the rollup condition against +child+.
      # @return [Boolean] may result in +nil+
      def evaluate(child)
        klass = self.class.const_get(rule_condition.delete(' ') + 'Evaluator')
        result = klass.new.call(child)
        if result.nil?
          nil
        elsif flip?
          !result
        else
          result
        end
      end

      private

      def flip?
        'Not' == rule_condition_operator
      end
    end
  end
end
