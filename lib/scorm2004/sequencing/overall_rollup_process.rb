require 'scorm2004/sequencing'
require 'scorm2004/sequencing/measure_rollup_process'
require 'scorm2004/sequencing/completion_measure_rollup_process'
require 'scorm2004/sequencing/objective_rollup_using_measure_process'
require 'scorm2004/sequencing/objective_rollup_using_rules_process'
require 'scorm2004/sequencing/objective_rollup_using_default_rule_process'
require 'scorm2004/sequencing/activity_progress_rollup_using_measure_process'
require 'scorm2004/sequencing/activity_progress_rollup_using_rules_process'
require 'scorm2004/sequencing/activity_progress_rollup_using_default_rule_process'

module Scorm2004
  module Sequencing
    # Overall Rollup Process [RB.1.5]
    #
    # @example
    #   OverallRollupProcess.new.call(activity
    class OverallRollupProcess
      def call(activity)
        activity.ancesters(true).each do |a|
          rollup(a)
        end
      end

      private

      def rollup(activity)
        unless activity.children.empty?
          MeasureRollupProcess.new.call(activity)
          CompletionMeasureRollupProcess.new.call(activity)
        end
        apply_appropriate_objective_rollup_process(activity)
        apply_appropriate_activity_progress_rollup_process(activity)
      end

      # Objective Rollup Process (SN 4.6.5)
      #
      # 1. Using Measure: If the rolled-up objective has Objective Satisfied
      #    by Measure equal to True,
      #
      # 2. Using Rules: If any rollup rules are defined on the activity that
      #    have the actions satisfied or not satisfied,
      #
      # 3. Default Rules – If no rollup rules are defined on the activity that
      #    have the actions satisfied or not satisfied,
      def apply_appropriate_objective_rollup_process(activity)
        o = activity.rolled_up_objective or return
        if o.satisfied_by_measure
          ObjectiveRollupUsingMeasureProcess.new.call(activity)
        elsif activity.rollup_rules('Satisfied', 'Not Satisfied').any?
          ObjectiveRollupUsingRulesProcess.new.call(activity)
        else
          ObjectiveRollupUsingDefaultRule.new.call(activity)
        end
      end

      # Activity Progress Rollup Process (SN 4.6.6)
      #
      # 1. Using Measure: If the activity has Completed by Measure equal to
      #    True,
      #
      # 2. Using Rules: If any rollup rules are defined on the activity that
      #    has the actions complete or incomplete,
      #
      # 3. Default Rule: If no rollup rules are defined on the activity that
      #    have the actions complete or incomplete,
      def apply_appropriate_activity_progress_rollup_process(activity)
        if activity.completed_by_measure
          ActivityProgressRollupUsingMeasureProcess.new.call(activity)
        elsif activity.rollup_rules('Complete', 'Incomplete').any?
          ActivityProgressRollupUsingRulesProcess.new.call(activity)
        else
          ActivityProgressRollupUsingDefaultRuleProcess.new.call(activity)
        end
      end
    end
  end
end
