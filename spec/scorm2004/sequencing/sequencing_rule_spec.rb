require 'spec_helper'
require 'scorm2004/sequencing/sequencing_rule'

describe Scorm2004::Sequencing::SequencingRule do
  describe 'Description' do
    context 'default values' do
      subject do
        described_class.new({'rule_conditions' => {}})
      end

      its(:condition_combination) { should == 'All' }
      its(:rule_conditions) { should be_empty }
      its(:rule_action) { should be_empty }
    end

    context 'example' do
      subject do
        described_class.new( {
            'rule_conditions' => {
              'condition_combination' => 'any',
              'rule_conditions' => [ {}, {}]
            },
            'rule_action' => { 'action' => 'stopForwardTraversal' }
          } )
      end

      its(:condition_combination) { should == 'Any'}
      its(:conditions) { should have(2).rule_conditions }
      its(:rule_action) { should == 'Stop Forward Traversal'}
    end
  end

  describe '#check' do
    it 'responds to #check' do
      described_class.new(:dummy).should respond_to(:check)
    end

    it 'invokes SequencingRuleCheckSubprocess' do
      subproc = double('sequencing rule check subprocess')
      subproc.should_receive(:call)
      klass = double('SequencingRuleCheckSubprocess')
      klass.should_receive(:new).and_return(subproc)
      stub_const('Scorm2004::Sequencing::SequencingRuleCheckSubprocess', klass)
      described_class.new(:dummy).check(:dummy)
    end
  end
end
