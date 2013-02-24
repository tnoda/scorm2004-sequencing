require 'scorm2004/sequencing'
require 'scorm2004/sequencing/rollup_rule'

module Scorm2004
  module Sequencing
    module RollupRules

      # @param *args [Array<String>] rollup actions
      # @example
      #   activity.rollup_rules #=> all rollup rules included in the activity
      #   activity.rollup_rules('Satisfied') #=> rollup rules whose Rollup Action is Satisfied
      #   activity.rollup_rules('Satisfied', 'Not Satisfied')
      #
      def rollup_rules(*args)
        bag = item['rollup_rules'].to_h['rollup_rules'].to_a.map do |rollup_rule|
          RollupRule.new(rollup_rule)
        end
        if args.empty?
          bag
        else
          bag.find_all { |rule| args.include?(rule.action) }
        end
      end
    end
  end
end
