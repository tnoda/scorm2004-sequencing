require 'scorm2004/sequencing'
require 'scorm2004/sequencing/sequencing_rules_check_process'

module Scorm2004
  module Sequencing
    class Activity
      # Invoke Sequencing Rules Check Process.
      #
      # @return [String, nil] the action to apply or nil
      # @example
      #   activity.check_sequencing_rules('Skip', 'Disabled', 'Exit')
      #
      def check_sequencing_rules(*args)
        SequencingRulesCheckProcess.new(self).call(*args)
      end
    end
  end
end
