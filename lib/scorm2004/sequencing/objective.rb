require 'scorm2004/sequencing'
require 'scorm2004/sequencing/cam/objective'
require 'scorm2004/sequencing/objective_progress_information'

module Scorm2004
  module Sequencing
    class Objective
      include Cam::Objective
      include ObjectiveProgressInformation

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
