require 'spec_helper'
require 'scorm2004/sequencing/sequencing_exit_action_rules_subprocess'

describe Scorm2004::Sequencing::SequencingExitActionRulesSubprocess do
  shared_context 'dumb activity' do
    def dumb_activity
      a = double('dumb activity')
      a.stub(:check_sequencing_rules).and_return(nil)
      a
    end
  end


  context 'no activities with the Exit action rule' do
    include_context 'dumb activity'

    it 'does nothing' do
      ancestors = Array.new(5) { dumb_activity }
      current_activity = double('current activity')
      current_activity.should_receive(:ancestors).and_return(ancestors)
      tree = double('activity tree')
      tree.should_receive(:current_activity).and_return(current_activity)
      described_class.new(tree).call
    end
  end

  context 'found a target activity' do
    include_context 'dumb activity'

    it 'do something against the target activity' do
      target_activity = double('target activity')
      target_activity.should_receive(:end_attempt)
      target_activity.should_receive(:check_sequencing_rules).and_return('Exit')
      tda_proc = double('terminate descendent attempt process')
      tda_proc.should_receive(:call).with(target_activity)
      klass = double('TerminateDescendentAttemptsProcess')
      klass.should_receive(:new).and_return(tda_proc)
      stub_const('Scorm2004::Sequencing::TerminateDescendentAttemptsProcess', klass)
      ancestors = (Array.new(4) { dumb_activity } << target_activity).shuffle
      current_activity = double('current activity')
      current_activity.should_receive(:ancestors).and_return(ancestors)
      tree = double('activity tree')
      tree.should_receive(:current_activity).and_return(current_activity)
      tree.should_receive(:current_activity=).with(target_activity)
      described_class.new(tree).call
    end
  end
end
