require 'scorm2004/sequencing'
require 'forwardable'

module Scorm2004
  module Sequencing
    # Sequencing Rule Check Subprocess [UP.2.1]
    #
    # @example
    #   SequencingRuleCheckSubprocess.new(sequencing_rule).call(activity)
    class SequencingRuleCheckSubprocess
      extend Forwardable
      def_delegators :@sequencing_rule, :rule_conditions, :condition_combination

      def initialize(sequencing_rule)
        @sequencing_rule = sequencing_rule
      end

      def call(activity)
        bag = rule_conditions.map { |cond| cond.evaluate(activity) }
        return if bag.empty?
        case condition_combination
        when 'All'
          bag.all?
        when 'Any'
          bag.any?
        else
          "invalid Condition Combination: #{condition_combination}"
        end
      end
    end
  end
end
