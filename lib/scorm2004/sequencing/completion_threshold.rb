require 'scorm2004/sequencing'

module Scorm2004
  module Sequencing
    module CompletionThreshold
      { 'completed_by_measure' => false,
        'progress_weight' => 1.0
      }.each do |attr, default|
        define_method(attr) do
          v = completion_threshold[attr]
          v.nil? ? default : v
        end
      end

      def minimum_progress_measure
        completion_threshold['min_progress_measure'] || 1.0
      end

      private

      def completion_threshold
        item['completion_threshold'].to_h
      end
    end
  end
end
