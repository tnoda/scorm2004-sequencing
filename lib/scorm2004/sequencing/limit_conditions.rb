require 'scorm2004/sequencing'

module Scorm2004
  module Sequencing
    module LimitConditions
      def limit_condition_attempt_limit_control
        !limit_condition_attempt_limit.nil?
      end

      def limit_condition_attempt_limit
        limit_conditions['attemptLimit']
      end

      def limit_condition_attempt_absolute_duration_control
        !limit_condition_attempt_absolute_duration_limit.nil?
      end

      def limit_condition_attempt_absolute_duration_limit
        limit_conditions['attemptAbsoluteDurationLimit']
      end

      private

      def limit_conditions
        sequencing['limit_conditions'].to_h
      end
    end
  end
end
