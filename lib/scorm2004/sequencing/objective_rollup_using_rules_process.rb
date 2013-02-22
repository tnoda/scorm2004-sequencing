require 'scorm2004/sequencing'
require 'scorm2004/sequencing/rollup_rule_check_subprocess'

module Scorm2004
  module Sequencing
    # Objective Rollup Using Rules Process [RB.1.2b]
    #
    # @example
    #   ObjectiveRollupUsingRulesProcess.new.call(activity)
    class ObjectiveRollupUsingRulesProcess
      def call(activity)
        ro = activity.rolled_up_objective or return

        if subproc.call(activity, 'Not Satisfied')
          ro.progress_status = true
          ro.satisfied_status = false
        end

        if subproc.call(activity, 'Satisfied')
          ro.progress_status = true
          ro.satisfied_status = true
        end
      end

      private

      def subproc
        RollupRuleCheckSubprocess.new
      end
    end
  end
end
