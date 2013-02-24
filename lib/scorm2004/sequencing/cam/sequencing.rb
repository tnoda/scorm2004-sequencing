require 'scorm2004/sequencing/cam'

module Scorm2004
  module Sequencing
    module Cam
      module Sequencing
        def sequencing
          referenced_sequencing.to_h.merge(local_sequencing)
        end

        private

        def local_sequencing
          item['sequencing'].to_h
        end

        def referenced_sequencing
          id_ref = local_sequencing['id_ref']
          if id_ref
            sequencing_collection.find { |s|
              s['id'] == id_ref
            } or raise "referenced sequencing not found; id_ref = #{id_ref}"
          end
        end

        def sequencing_collection
          manifest['sequencing_collection'].to_h['sequencings'].to_a
        end
      end
    end
  end
end
