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
        sequencing['objectives'].to_h['objectives'].to_a.map do |desc|
          Objective.new(self, desc, status)
        end
      end

      def primary_objective
        desc = sequencing['objectives'].to_h['primary_objective']
        desc && Objective.new(self, desc, status)
      end
    end
  end
end
