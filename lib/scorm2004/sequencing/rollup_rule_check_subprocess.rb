require 'scorm2004/sequencing'

module Scorm2004
  module Sequencing
    # Rollup Rule Check Subprocess [RB.1.4]
    #
    # @example Apply the Rollup Rule Check Subprocess for an +activity+ and a Rollup Action
    #   RollupRuleCheckSubprocess.new.call(activity, 'Satisfied')
    class RollupRuleCheckSubprocess
      def call(activity, rollup_action)
        activity.rollup_rules(rollup_action).any? do |rollup_rule|
          bag = children(activity, rollup_action).map do |c|
            rollup_rule.evaluate(c) # Evaluate Rollup Conditions Subprocess
          end
          !bag.empty? &&
            case rollup_rule.child_activity_set
            when /All/i
              bag.all?
            when /Any/i
              bag.any?
            when /None/i
              bag.all? { |v| v == false }
            when /At Least Count/i
              bag.count { |a| a } >= rollup_rule.minimum_count
            when /At Least Percent/i
              ratio = bag.count { |a| a }.to_f / bag.count
              ratio >= rollup_rule.minimum_percent
            else
              raise "invalid Rollup Child Activity Set: #{rollup_rule.child_activity_set}"
            end
        end
      end

      private

      def children(activity, rollup_action)
        activity.children.find_all do |c|
          c.tracked? && c.included_in_rollup?(rollup_action)
        end
      end
    end
  end
end
