require 'spec_helper'
require 'scorm2004/sequencing/sequencing_exception'

describe Scorm2004::Sequencing::SequencingException do
  subject { Object.new.extend(Scorm2004::Sequencing::SequencingException) }

  describe '#exception' do
    it 'throws :sequencing_exception and sets @exception' do
      expect {
        subject.sequencing_exception('dummy code')
      }.to throw_symbol(:sequencing_exception)
      subject.exception { should be }
    end
  end
end
