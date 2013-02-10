require 'scorm2004/sequencing'

module Scorm2004
  module Sequencing
    module Item
      def identifier
        @item['identifier']
      end

      def title
        @item['title']
      end
    end
  end
end
