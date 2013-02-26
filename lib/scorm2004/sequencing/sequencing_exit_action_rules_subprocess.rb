require 'scorm2004/sequencing'
require 'scorm2004/sequencing/terminate_descendent_attempts_process'
require 'forwardable'

module Scorm2004
  module Sequencing
    # Sequencing Exit Action Rules Subprocess [TB.2.1]
    #
    # @example
    #   SequencingExitActionRulesSubprocess.new(tree).call
    #
    class SequencingExitActionRulesSubprocess
      extend Forwardable
      def_delegators :@tree, :current_activity

      # @param tree <ActivityTree> the activity tree
      def initialize(tree)
        @tree = tree
      end

      def call
        return unless exit_target
        exit_target.end_attempt
        TerminateDescendentAttemptsProcess.new(@tree).call(exit_target)
        @tree.current_activity = exit_target
      end

      private

      def exit_target
        # Form the activity path as the ordered series of activities from the
        # root of the activity tree to the parent of the Current Activity,
        # inclusive.
        #
        # Evaluate all exit rules along the active path, starting at the root of
        # the activity tree.
        @exit_target ||= current_activity.ancestors(true).reverse.find do |activity|
          activity.check_sequencing_rules('Exit')
        end
      end
    end
  end
end
