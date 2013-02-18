require 'scorm2004/sequencing'

module Scorm2004
  module Sequencing
    module ObjectiveProgressInformation
      ELEMENTS_AND_DEFAULTS = {
        'progress_status' => false,
        'satisfied_status' => false,
        'measure_status' => false,
        'normalized_measure' => 0.0,
        'completion_status' => false,
        'completion_amount_status' => false,
        'completion_amount' => 0.0
      }

      MAPPINGS = {
        'satisfied_status' => [
          'progress_status',
          'satisfied_status'
        ],
        'normalized_measure' => [
          'measure_status',
          'normalized_measure'
        ]
      }

      ELEMENTS_AND_DEFAULTS.each do |attr, default|
        define_method("local_#{attr}") do
          v = local[attr]
          v.nil? ? default : v
        end

        define_method("local_#{attr}=".intern) do |obj|
          local[attr] = obj
        end

        define_method(attr.intern) do
          l = send("local_#{attr}".intern)
          g = if MAPPINGS.values.flatten.include?(attr)
                send("global_#{attr}".intern)
              end
          g.nil? ? l : g
        end

        define_method("#{attr}=".intern) do |obj|
          if MAPPINGS.values.flatten.include?(attr)
            send("global_#{attr}=".intern, obj)
          end
          send("local_#{attr}=".intern, obj)
        end
      end

      MAPPINGS.each do |flag, attrs|
        attrs.each do |attr|
          define_method("global_#{attr}".intern) do
            m = map_infos.find { |m| m.send("read_#{flag}".intern) }
            m && global(m.target_objective_id)[attr]
          end

          define_method("global_#{attr}=".intern) do |obj|
            map_infos.find_all { |m|
              m.send("write_#{flag}".intern)
            }.each do |m|
              global(m.target_objective_id)[attr] = obj
            end
          end
        end
      end

      private

      def local_objective_progress_information
        (((@state['activities'] ||= {})[identifier] ||= {})['objectives'] ||= {})[id] ||= {}
      end
      alias :local :local_objective_progress_information

      def shared_global_objective_progress_information(target_objective_id)
        (@state['objectives'] ||= {})[target_objective_id] ||= {}
      end
      alias :global :shared_global_objective_progress_information
    end
  end
end
