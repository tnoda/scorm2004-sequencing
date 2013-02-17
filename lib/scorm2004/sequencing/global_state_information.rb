require 'scorm2004/sequencing'

module Scorm2004
  module Sequencing
    module GlobalStateInformation
      %w( current_activity suspended_activity ).each do |attr|
        define_method(attr.intern) do
          global_state_information[attr]
        end

        define_method("#{attr}=") do |flag|
          global_state_information[attr] = flag
        end
      end

      private

      def global_state_information
        @state['global_state_information'] ||= {}
      end
    end
  end
end
