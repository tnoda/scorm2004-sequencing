require 'scorm2004/sequencing'

module Scorm2004
  module Sequencing
    module SequencingRules
      # @return [Array<SequencingRule>] the sequencing rules of the activity.
      # @example
      #   activity.sequencing_rules #=> all sequencing rules included in the activity.
      #   activity.sequencing_rules('Skip', 'Disabled') #=> sequencing rules whose rule action is 'Skip' or 'Disabled'
      #
      def sequencing_rules(*args)
        sequencing['sequencing_rules'].to_h.values.flatten(1).map { |desc|
          SequencingRule.new(desc)
        }.find_all { |r|
          args.empty? || args.include?(r.rule_action)
        }
      end
    end
  end
end
