require 'scorm2004/sequencing'

module Scorm2004
  module Sequencing
    module RollupRuleDescription
      def action
        action = (rule['rollup_action'] || {})['action']
        case action
        when 'satisfied'
          'Satisfied'
        when 'notSatisfied'
          'Not Satisfied'
        when 'completed'
          'Completed'
        when 'incmoplete'
          'Incomplete'
        else
          'Satisfied'
        end
      end

      def condition_combination
        combi = (rule['rollup_conditions'] || {})['condition_combination']
        (/all/i =~ combi) ? 'All' : 'Any'
      end

      def child_activity_set
        case rule['child_activity_set']
        when /all/i
          'All'
        when /any/i
          'Any'
        when /none/i
          'None'
        when /atLeastCount/i
          'At Least Count'
        when /atLeastPercent/i
          'At Least Percent'
        else
          'All'
        end
      end

      def conditions
        ((rule['rollup_conditions'] || {})['rollup_conditions'] || []).map do |condition|
          RollupCondition.build(condition)
        end
      end

      def minimum_percent
        rule['minimum_percent'] || 0.0
      end

      def minimum_count
        rule['minimum_count'] || 0
      end
    end
  end
end
