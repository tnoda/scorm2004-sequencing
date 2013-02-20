require 'scorm2004/sequencing'

module Scorm2004
  module Sequencing
    class ObjectiveRollupUsingMeasureProcess
      def call(activity)
        @activity = activity
        return unless ro && ro.satisfied_by_measure
        if !ro.measure_status || (active? && !measure_satisfaction_if_active)
          ro.progress_status = false
          return
        end
        ro.progress_status = true
        ro.satisfied_status = (ro.normalized_measure >= ro.minimum_satisfied_normalized_measure)
      end

      private

      def rolled_up_objective
        @activity.rolled_up_objective
      end
      alias :ro :rolled_up_objective

      def active?
        @activity.active?
      end

      def measure_satisfaction_if_active
        @activity.measure_satisfaction_if_active
      end
    end
  end
end
