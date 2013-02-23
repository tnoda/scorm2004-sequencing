require 'spec_helper'
require 'scorm2004/sequencing/rollup_rule'

describe Scorm2004::Sequencing::RollupRule do
  describe '#evaluate' do
    it 'calls EvaluateRollupConditionsSubprocess' do
      subproc = double('subprocess')
      subproc.should_receive(:call).with(:dummy_child)
      klass = double('EvaluateRollupConditionsSubprocess')
      klass.stub(:new => subproc)
      stub_const('Scorm2004::Sequencing::EvaluateRollupConditionsSubprocess', klass)
      described_class.new(:dummy_rule).evaluate(:dummy_child)
    end
  end
end
