require 'scorm2004/sequencing'

module Scorm2004
  module Sequencing
    class MeasureRollupProcess
      def initialize(activity = nil)
        @activity = activity
      end

      def call(activity = nil)
        @activity = activity if activity
        return unless rolled_up_objective
        if valid_children.empty? || counted_measures <= 0.0
          rolled_up_objective.measure_status = false
          return
        end
        rolled_up_objective.measure_status = true
        rolled_up_objective.normalized_measure =
          total_weighted_measure / counted_measures
      end

      private

      def rolled_up_objective
        @activity.rolled_up_objective
      end

      def children
        @activity.children.find_all { |c| c.tracked? && c.rolled_up_objective }
      end

      def valid_children
        children.find_all { |c| c.rolled_up_objective.measure_status }
      end

      def counted_measures
        valid_children.map(&:rollup_objective_measure_weight).reduce(&:+)
      end

      def total_weighted_measure
        valid_children.map { |c|
          c.rollup_objective_measure_weight *
          c.rolled_up_objective.normalized_measure
        }.reduce(&:+)
      end
    end
  end
end
