require 'scorm2004/sequencing'

module Scorm2004
  module Sequencing
    # Activity Progress Rollup Using Default Rule Process derived from
    # Activity Progress Rollup Using Rules Process [RB.1.3b]
    #
    # @example
    #   ActivityProgressRollupUsingDefaultRuleProcess.new.call(activity
    class ActivityProgressRollupUsingDefaultRuleProcess

      # @param a [Activity] the activity
      def call(a)
        # Apply the default incomplete rule
        b = bag(a, 'Incomplete')
        if !b.empty? && b.all? { |c| c.attempt_progress_status }
          a.attempt_progress_status = true
          a.attempt_completion_status = false
        end

        # Apply the default completed rule
        b = bag(a, 'Completed')
        if !b.empty? && b.all? { |c|
            c.attempt_progress_status && c.attempt_completion_status
          }
          a.attempt_progress_status = true
          a.attempt_completion_status = true
        end
      end

      private

      def bag_of_children(activity, rollup_action)
        activity.children.find_all { |c|
          c.tracked? && c.included_in_rollup?(rollup_action)
        }
      end
      alias :bag :bag_of_children
    end
  end
end
