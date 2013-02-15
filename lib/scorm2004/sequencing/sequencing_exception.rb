require 'scorm2004/sequencing'

module Scorm2004
  module Sequencing
    module SequencingException
      # Throws +:sequencing_exception+ and sets the sequencing
      # exception code.
      # @param code [String] The sequencing exception code.
      def sequencing_exception(code)
        @exception = code
        throw :sequencing_exception
      end

      # Returns +:@exception+.
      def exception
        @exception
      end
    end
  end
end
