require 'scorm2004/sequencing'
require 'scorm2004/sequencing/objective'

module Scorm2004
  module Sequencing
    module Objectives
      # @return [Array<Objective>] the objectives that belongs to this activity.
      def objectives
        po = primary_objective
        unless po
          []
        else
          [po] + secondary_objectives
        end
      end

      # @return [Objective] the objective that contributes to rollup.
      def rolled_up_objective
        objectives.first
      end

      private

      def secondary_objectives
        ((sequencing['objectives'] || {})['objectives'] || []).map do |o|
          Objective.new(self, o, status)
        end
      end
      def primary_objective
        po = (sequencing['objectives'] || {})['primary_objective']
        po && Objective.new(self, po, status)
      end
    end
  end
end
