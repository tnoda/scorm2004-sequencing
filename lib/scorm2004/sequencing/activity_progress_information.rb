require 'scorm2004/sequencing'

module Scorm2004
  module Sequencing
    module ActivityProgressInformation
      { 'activity_progress_status' => false,
        'activity_absolute_duration' => 0.0,
        'activity_experienced_duration' => 0.0,
        'activity_attempt_count' => 0
      }.each do |attr, default|
        define_method(attr) do
          v = activity_progress_information[attr]
          v.nil? ? default : v
        end

        define_method("#{attr}=".intern) do |obj|
          activity_progress_information[attr] = obj
        end
      end

      private

      def activity_progress_information
        ((@state['activities'] ||= {})[@identifier] ||= {})['activity_progress_information'] ||= {}
      end
    end
  end
end
