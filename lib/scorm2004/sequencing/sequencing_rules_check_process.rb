require 'scorm2004/sequencing'
require 'forwardable'

module Scorm2004
  module Sequencing
    # Sequencing Rules Check Process [UP.2]
    #
    # @example
    #   SequencingRulesCheckProcess.new(activity).call('Skip', 'Disabled', ...)
    class SequencingRulesCheckProcess
      extend Forwardable
      def_delegators :@activity, :sequencing_rules

      def initialize(activity)
        @activity = activity
      end

      def call(*args)
        sequencing_rules(*args).find { |r| r.check(@activity) }
      end
    end
  end
end
