require 'scorm2004/sequencing'
require 'forwardable'

module Scorm2004
  module Sequencing
    class EvaluateRollupConditionsSubprocess
      extend Forwardable
      def_delegators :@rule, :conditions, :condition_combination

      def initialize(rule)
        @rule = rule
      end

      def call(child)
        bag = conditions.map { |cond| cond.evaluate(child) }
        if bag.empty?
          nil
        elsif /Any/i =~ condition_combination
          bag.any?
        else
          bag.all?
        end
      end
    end
  end
end
