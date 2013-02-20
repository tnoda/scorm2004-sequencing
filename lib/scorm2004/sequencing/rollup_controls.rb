require 'scorm2004/sequencing'

module Scorm2004
  module Sequencing
    module RollupControls
      { 'rollup_objective_satisfied' => true,
        'rollup_objective_measure_weight' => 0.0,
        'rollup_progress_completion' => true
      }.each do |attr, default|
        define_method(attr.intern) do
          v = rollup_rules[attr]
          v.nil? ? default : v
        end
      end
    end
  end
end
