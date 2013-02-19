require 'scorm2004/sequencing'

module Scorm2004
  module Sequencing
    module AttemptProgressInformation
      { 'attempt_progress_status' => false,
        'attempt_completion_status' => false,
        'attempt_completion_amount_status' => false,
        'attempt_completion_amount' => 0.0,
        'attempt_absolute_duration' => 0.0,
        'attempt_experienced_duration' => 0.0
      }.each do |attr, default|
        define_method(attr.intern) do
          v = attempt_progress_information[attr]
          v.nil? ? default : v
        end

        define_method("#{attr}=".intern) do |obj|
          attempt_progress_information[attr] = obj
        end
      end

      private

      def attempt_progress_information
        ((state['activities'] ||= {})[identifier] ||= {})['attempt_progress_information'] ||= {}
      end
    end
  end
end
