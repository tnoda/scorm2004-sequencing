require 'scorm2004/sequencing'

module Scorm2004
  module Sequencing
    module Cam
      module Objective
        class MapInfo
          def initialize(obj)
            @map_info = obj
          end

          def target_objective_id
            map_info['target_objective_id']
          end

          [ 'satisfied_status',
            'normalized_measure',
            'min_score',
            'max_score',
            'completion_status',
            'progress_measure'
          ].each do |attr|
            rattr = "read_#{attr}"
            define_method(rattr.intern) do
              v = map_info[rattr]
              v.nil? ? true : v
            end

            wattr = "write_#{attr}"
            define_method(wattr.intern) do
              v = map_info[wattr]
              v.nil? ? false : v
            end
          end

          private

          def map_info
            @map_info
          end
        end

        def id
          objective['objective_id']
        end

        def satisfied_by_measure
          objective['satisfied_by_measure'] || false
        end

        def minimum_satisfied_normalized_measure
          objective['min_normalized_measure'] || 1.0
        end

        def map_infos
          (objective['map_infos'] || []).map { |map_info|
            MapInfo.new(map_info)
          }
        end

        private

        def objective
          @objective
        end
      end
    end
  end
end
