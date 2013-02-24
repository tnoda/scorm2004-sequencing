require 'spec_helper'
require 'scorm2004/sequencing/activity'

describe Scorm2004::Sequencing::Activity do
  describe '#check_sequencing_rules' do
    it 'should invoke SequencingRulesCheckProcess' do
      proc = double('sequencing rules check process')
      proc.should_receive(:call).with(:dummy0, :dummy1)
      klass = double('SequencingRulesCheckProcess')
      klass.stub(:new => proc)
      stub_const('Scorm2004::Sequencing::SequencingRulesCheckProcess', klass)
      subject.check_sequencing_rules(:dummy0, :dummy1)
    end
  end

  pending 'has not been implemented' do
    it { should respond_to(:root?) }
    it { should respond_to(:sequencing_control_flow) }
    it { should respond_to(:active?) }
    it { should respond_to(:sequencing_control_forward_only) }
    it { should respond_to(:sequencing_control_choice_exit) }
    it { should respond_to(:sequencing_control_choice) }
    it { should respond_to(:available?) }
    it { should respond_to(:identifier) }
    it { should respond_to(:children) }
    it { should respond_to(:end_attempt) }
    it { should respond_to(:rollup) }
    it { should respond_to(:suspended?) }
    it { should respond_to(:leaf?) }
    it { should respond_to(:tracked?) }
    it { should respond_to(:completion_set_by_content) }
    it { should respond_to(:objective_set_by_content) }
    it { should respond_to(:rolled_up_objective)}
    it { should respond_to(:item) }
    it { should respond_to(:sequencing) }
    it { should respond_to(:manifest) }
    it { should respond_to(:included_in_rollup?) } # Check Child for Rollup Subprocess
    it { should respond_to(:ancesters)}
    it { should respond_to(:completed?) }
  end
end
