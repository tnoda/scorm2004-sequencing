require 'scorm2004/sequencing'
require 'scorm2004/sequencing/cam/objective'
require 'scorm2004/sequencing/objective_progress_information'

module Scorm2004
  module Sequencing
    class Objective
      include Cam::Objective
      include ObjectiveProgressInformation

      # @param activity [Activity] The activity to which this objective belongs.
      # @param objective [Hash] The object representation of the <objective> or <primaryObjective> element.
      # @param state [Hash] The learner status.
      def initialize(activity, objective, state)
        @activity = activity
        @objective = objective || {}
        @state = state || {}
      end

      def satisfied?
        progress_status && satisfied_status
      end

      private

      def identifier
        @activity.identifier
      end
    end
  end
end
