require 'spec_helper'
require 'scorm2004/sequencing/process_factory'

describe Scorm2004::Sequencing::ProcessFactory do
  Scorm2004::Sequencing::ProcessFactory::ACTIVITY_TREE_PROCESSES.each do |sym|
    describe "##{sym}" do
      it "instantiates #{sym.to_s.split('_').map(&:capitalize).join('')}" do
        def classify(sym)
          Scorm2004::Sequencing.const_get(sym.to_s.split('_').map(&:capitalize).join(''))
        end
        klass = classify(sym)
        mock = double(klass.to_s)
        mock.should_receive(:new).with(:dummy_activity_tree).and_return(:dummy_instance)
        stub_const(klass.to_s, mock)
        described_class.new(:dummy_activity_tree).send(sym).should == :dummy_instance
      end
    end
  end
end
