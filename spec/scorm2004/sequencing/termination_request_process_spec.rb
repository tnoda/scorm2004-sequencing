require 'spec_helper'
require 'scorm2004/sequencing/termination_request_process'

describe Scorm2004::Sequencing::TerminationRequestProcess do
  context 'Abandon termination request' do
    it 'sets Activity is Active to False' do
      current_activity = double('current_activity')
      current_activity.stub(:active? => true)
      current_activity.should_receive(:activity_is_active=).with(false)
      tree = double('activity tree')
      tree.stub(current_activity: current_activity)
      described_class.new(tree).call(:abandon)
    end
  end

  context 'Abandon All termination request' do
    it 'sets ancestors\' Activity is Active to false' do
      def ancestor
        a = double('ancestor')
        a.should_receive(:activity_is_active=).with(false)
        a
      end
      current_activity = double('current_activity')
      current_activity.stub(:ancestors => Array.new(3) { ancestor } )
      tree = double('activity tree')
      tree.stub(:current_activity => current_activity)
      tree.should_receive(:root_activity).and_return(:dummy_root)
      tree.should_receive(:current_activity=).with(:dummy_root)
      described_class.new(tree).call(:abandon_all)
    end
  end

  context 'Suspend All termination request' do
    let(:suspended_activity) do
      def ancestor
        a = double('ancestor')
        a.should_receive(:activity_is_active=).with(false)
        a.should_receive(:activity_is_suspended=).with(true)
        a
      end
      suspended_activity = double('suspended activity')
      suspended_activity.stub(:ancestors => Array.new(3) { ancestor } )
      suspended_activity
    end


    context 'when the current activity is active and suspended' do
      it 'rollups and suspends the current activity' do
        current_activity = double('current activity')
        current_activity.should_receive(:active?).and_return(true)
        current_activity.should_receive(:suspended?).and_return(true)
        current_activity.should_receive(:rollup)
        tree = double('activity tree')
        tree.stub(:current_activity => current_activity,
          :suspended_activity => suspended_activity,
          :root_activity => :dummy_root)
        tree.should_receive(:suspended_activity=).with(current_activity)
        tree.should_receive(:current_activity=).with(:dummy_root)
        described_class.new(tree).call(:suspend_all)
      end
    end
  end

  context 'Exit All termination request' do
    it 'applies subprocesses and returns the exit sequencing request' do
      current_activity = double('current activity')
      current_activity.should_receive(:active?).and_return(true)
      current_activity.should_receive(:end_attempt)
      root_activity = double('root activity')
      root_activity.should_receive(:end_attempt)
      terminate_descendent_attempts_process = double('Terminate Descendent Attempts Process')
      terminate_descendent_attempts_process.stub(:new).and_return(terminate_descendent_attempts_process)
      terminate_descendent_attempts_process.should_receive(:call).with(root_activity)
      stub_const('Scorm2004::Sequencing::TerminateDescendentAttemptsProcess',
        terminate_descendent_attempts_process)
      tree = double('activity tree')
      tree.stub(:current_activity => current_activity, :root_activity => root_activity)
      tree.should_receive(:current_activity=).with(root_activity)
      proc = described_class.new(tree)
      described_class.new(tree).call(:exit_all)
    end
  end
end
