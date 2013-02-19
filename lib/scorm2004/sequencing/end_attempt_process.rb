require 'scorm2004/sequencing'

module Scorm2004
  module Sequencing
    module EndAttemptProcess
      def end_attempt
        if leaf?
          leaf_end_attempt_process
        else
          cluster_end_attempt_process
        end

        self.activity_is_active = false
        rollup
      end

      private

      def leaf_end_attempt_process
        return unless tracked? && !suspended?

        if !completion_set_by_content && !attempt_progress_status
          self.attempt_progress_status = true
          self.attempt_completion_status = true
        end

        if !objective_set_by_content
          ro = rolled_up_objective
          if ro && !ro.progress_status
            ro.progress_status = true
            ro.satisfied_status = true
          end
        end
      end

      def cluster_end_attempt_process
        flag = children.any?(&:suspended?)
        if flag
          self.activity_is_suspended = flag
        end
      end
    end
  end
end
