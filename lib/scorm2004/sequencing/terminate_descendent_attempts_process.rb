require 'scorm2004/sequencing'
require 'forwardable'

module Scorm2004
  module Sequencing
    # Terminate Descendent Attempts Process [UP.3]
    #
    # @example
    #   TerminateDescendentAttemptsProcess.new(tree).call(activity)
    class TerminateDescendentAttemptsProcess
      extend Forwardable
      def_delegators :@tree, :current_activity, :common_ancestor

      # @param tree <ActivityTree> the activity tree
      def initialize(tree)
        @tree = tree
      end

      def call(activity)
        # Find the activity that is the common ancestor of the Current Activity
        # and the identified activity.
        # Form the activity path as the ordered series of activities from the
        # Current Activity to the common ancestor, exclusive of the Current
        # Activity and the common ancestor.
        activity_path = current_activity.ancestors(false) -
          common_ancestor(current_activity, activity).ancestors(true)
        activity_path.each(&:end_attempt)
      end
    end
  end
end
