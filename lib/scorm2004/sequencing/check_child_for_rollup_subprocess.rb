require 'scorm2004/sequencing'
require 'forwardable'

module Scorm2004
  module Sequencing
    # Check Child for Rollup Subprocess [RB.1.4.2]
    #
    # @example Apply the Check Child for Rollup Subprocess to a +child+ and a Rollup Action.
    #   CheckChildForRollupSubprocess.new('Satisfied').call(child)
    class CheckChildForRollupSubprocess
      extend Forwardable
      def_delegators(:@child,
        :rollup_objective_satisfied, :rollup_progress_completion,
        :required_for_satisfied, :required_for_not_satisfied,
        :required_for_completed, :required_for_incomplete,
        :activity_progress_status, :activity_attempt_count,
        :activity_is_suspended)

      def initialize(action)
        @action = action
      end

      def call(child)
        @child = child
        rollup_control &&
          (!required?('ifNotSuspended') || !suspended?) &&
          (!required?('ifAttempted') || attempted?) &&
          (!required?('ifNotSkipped') || !skipped)
      end

      private

      def rollup_control
        case rollup_action
        when /Satisfied|Not Satisfied/
          rollup_objective_satisfied
        when /Completed|Incomplete/
          rollup_progress_completion
        end
      end

      def rollup_action
        @action
      end

      def required?(cond)
        cond == case rollup_action
                when 'Satisfied'
                  required_for_satisfied
                when 'Not Satisfied'
                  required_for_not_satisfied
                when 'Completed'
                  required_for_completed
                when 'Incomplete'
                  required_for_incomplete
                else
                  raise "invalid Rollup Action: #{rollup_action}"
                end
      end

      def suspended?
        !activity_progress_status ||
          activity_attempt_count > 0 && activity_is_suspended
      end

      def attempted?
        activity_progress_status && activity_attempt_count > 0
      end

      def skipped?
        raise 'Apply the Sequencing Rules Check Process to the activity and its Skip sequencing rules.'
      end
    end
  end
end
