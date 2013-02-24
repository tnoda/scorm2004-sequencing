require 'scorm2004/sequencing'

module Scorm2004
  module Sequencing
    module RollupConsiderationControls
      { 'measure_satisfaction_if_active' => true,
        'required_for_satisfied' => 'always',
        'required_for_not_satisfied' => 'always',
        'required_for_completed' => 'always',
        'required_for_incomplete' => 'always'
      }.each do |attr, default|
        define_method(attr.intern) do
          v = rollup_considerations[attr]
          v.nil? ? default : v
        end
      end

      private

      def rollup_considerations
        sequencing['rollup_considerations'].to_h
      end
    end
  end
end
