require 'scorm2004/sequencing'
require 'ostruct'

module Scorm2004
  module Sequencing
    # Objective Rollup Using Default Rule derived from
    # Objective Rollup Using Rules Process [RB.1.2b] line 1.
    #
    # @example
    #   ObjectiveRollupUsingDefaultRule.new.call(activity)
    class ObjectiveRollupUsingDefaultRule
      def call(activity)
        return unless ro(activity)

        # Apply the default not satisfied rule
        nsb = bag(activity, 'Not Satisfied')
        if !nsb.empty? && nsb.all? { |cro| cro && cro.progress_status }
          ro(activity).progress_status = true
          ro(activity).satisfied_status = false
        end

        # Apply the default satisfied rule
        sb = bag(activity, 'Satisfied')
        if !sb.empty? && sb.all? { |cro| cro && cro.progress_status && cro.satisfied_status }
          ro(activity).progress_status = true
          ro(activity).satisfied_status = true
        end
      end

      private

      def rolled_up_objective(activity)
        activity.rolled_up_objective
      end
      alias :ro :rolled_up_objective

      def bag_of_child_rolled_up_objective(activity, rollup_action)
        activity.children.find_all { |c|
          c.tracked? && c.included_in_rollup?(rollup_action)
        }.map(&:rolled_up_objective)
      end
      alias :bag :bag_of_child_rolled_up_objective
    end
  end
end
