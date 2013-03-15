require 'scorm2004/sequencing'
require 'forwardable'

module Scorm2004
  module Sequencing
    class AbstractProcess
      include SequencingException

      attr_reader :tree

      ACTIVITY_TREE_METHODS = [
        :current_activity, :suspended_activity, :root_activity
      ]

      CURRENT_ACTIVITY_METHODS = [
        :active?, :suspended?, :root?,
        :end_attempt, :rollup, :check_sequencing_rules,
        :parent
      ]

      extend Forwardable
      def_delegators(:tree, *ACTIVITY_TREE_METHODS)
      def_delegators(:current_activity, *CURRENT_ACTIVITY_METHODS)
      def_delegators(:process_factory, *ProcessFactory::AVAILABLE_PROCESSES)

      # @param tree [ActivityTree] the activity tree
      def initialize(tree)
        @tree = tree
      end

      def set_current_activity(a)
        @tree.current_activity = a
      end

      private

      def process_factory
        @process_factory ||= ProcessFactory.new(@tree)
      end
    end
  end
end
