require 'scorm2004/sequencing'

module Scorm2004
  module Sequencing
    class ProcessFactory
      ACTIVITY_TREE_PROCESSES = [
        :termination_request_process, # TB.2.3
        :sequencing_exit_action_rules_subprocess,
        :terminate_descendent_attempts_process
      ]

      AVAILABLE_PROCESSES = [
        ACTIVITY_TREE_PROCESSES
      ].flatten

      class << self
        def register(*args)
          args.each do |m|
            define_method(m) do
              classify(m).new(@tree)
            end
          end
        end
      end

      register *ACTIVITY_TREE_PROCESSES

      def initialize(tree)
        @tree = tree
      end

      def classify(sym)
        Sequencing.const_get(sym.to_s.split('_').map(&:capitalize).join(''))
      end
    end
  end
end
