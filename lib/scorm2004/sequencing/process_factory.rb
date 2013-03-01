require 'scorm2004/sequencing'
require 'scorm2004/sequencing/sequencing_exit_action_rules_subprocess'
require 'scorm2004/sequencing/terminate_descendent_attempts_process'

module Scorm2004
  module Sequencing
    class ProcessFactory
      ACTIVITY_TREE_PROCESSES = [
        :sequencing_exit_action_rules_subprocess,
        :terminate_descendent_attempts_process
      ]

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
