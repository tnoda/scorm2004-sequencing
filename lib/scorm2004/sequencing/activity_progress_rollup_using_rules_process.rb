require 'scorm2004/sequencing'
require 'scorm2004/sequencing/rollup_rule_check_subprocess'

module Scorm2004
  module Sequencing
    # Activity Rollup Using Rules Process [RB.1.3b]
    #
    # @example
    #   ActivityRollupUsingRulesProcess.new.call(activity
    #
    class ActivityProgressRollupUsingRulesProcess
      # @param a [String] the activity
      def call(a)
        if subproc.call(a, 'Incomplete')
          a.attempt_progress_status = true
          a.attempt_completion_status = false
        end

        if subproc.call(a, 'Complete')
          a.attempt_progress_status = true
          a.attempt_completion_status = true
        end
      end

      private

      def subproc
        RollupRuleCheckSubprocess.new
      end
    end
  end
end
