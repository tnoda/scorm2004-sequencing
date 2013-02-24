require 'scorm2004/sequencing'

module Scorm2004
  module Sequencing
    module DeliveryControls
      { 'tracked' => true,
        'completion_set_by_content' => false,
        'objective_set_by_content' => false
      }.each do |attr, default|
        define_method(attr.intern) do
          v = delivery_controls[attr]
          v.nil? ? default : v
        end
      end

      private

      def delivery_controls
        sequencing['delivery_controls'].to_h
      end
    end
  end
end
