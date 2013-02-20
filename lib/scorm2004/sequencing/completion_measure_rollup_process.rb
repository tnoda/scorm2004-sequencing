require 'scorm2004/sequencing'

module Scorm2004
  module Sequencing
    class CompletionMeasureRollupProcess
      def call(activity)
        @activity = activity

        if valid_children.empty? || counted_measure <= 0.0
          @activity.attempt_completion_amount_status = false
          return
        end
        
        @activity.attempt_completion_amount_status = true
        @activity.attempt_completion_amount =
          total_weighted_measure / counted_measure
      end

      private

      def children
        @activity.children.find_all(&:tracked?)
      end

      def valid_children
        children.find_all(&:attempt_completion_amount_status)
      end

      def counted_measure
        children.map(&:progress_weight).reduce(&:+)
      end

      def total_weighted_measure
        children.map { |c|
          c.attempt_completion_amount * c.progress_weight
        }.reduce(&:+)
      end
    end
  end
end
