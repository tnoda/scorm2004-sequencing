require 'scorm2004/sequencing'

module Scorm2004
  module Sequencing
    module ActivityStateInformation
      { 'activity_is_active' => false,
        'activity_is_suspended' => false,
      }.each do |attr, default|
        define_method(attr.intern) do
          v = activity_state_information[attr]
          v.nil? ? default : v
        end

        define_method("#{attr}=".intern) do |obj|
          activity_state_information[attr] = obj
        end
      end

      def available_children
        activity_state_information['available_children'] ||= children.map(&:identifier)
      end

      def available_children=(obj)
        activity_state_information['available_children'] = obj
      end

      private

      def activity_state_information
        ((@state['activities'] ||= {})[@identifier] ||= {})['activity_state_information'] ||= {}
      end
    end
  end
end
