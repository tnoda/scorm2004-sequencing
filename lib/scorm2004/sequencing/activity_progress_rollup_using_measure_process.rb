require 'scorm2004/sequencing'

module Scorm2004
  module Sequencing
    # Activity Progress Rollup Using Measure Process [RB.1.3a]
    #
    # @example
    #   ActivityProgressRollupUsingMeasureProcess.new.call(activity)
    #
    class ActivityProgressRollupUsingMeasureProcess

      # @param a [Activity] the activty
      def call(a)
        if a.completed_by_measure && a.attempt_completion_amount_status
          a.attempt_progress_status = true
          a.attempt_completion_status =
            a.attempt_completion_amount >= a.minimum_progress_measure
        else
          a.attempt_progress_status = false
          a.attempt_completion_status = false
        end
      end
    end
  end
end
