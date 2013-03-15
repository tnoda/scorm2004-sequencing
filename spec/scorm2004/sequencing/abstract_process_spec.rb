require 'spec_helper'
require 'scorm2004/sequencing/abstract_process'

describe Scorm2004::Sequencing::AbstractProcess do

  describe 'has an activity tree' do
    subject do
      tree = double('tree')
      Scorm2004::Sequencing::AbstractProcess::ACTIVITY_TREE_METHODS.each do |m|
        tree.should_receive(m).and_return(:dummy)
      end
      described_class.new(tree)
    end

    it 'forwards some methods to the activity tree' do
      Scorm2004::Sequencing::AbstractProcess::ACTIVITY_TREE_METHODS.each do |m|
        subject.send(m).should == :dummy
      end
    end
  end

  describe 'has a current activity' do
    subject do
      current_activity = double('current activity')
      Scorm2004::Sequencing::AbstractProcess::CURRENT_ACTIVITY_METHODS.each do |m|
        current_activity.should_receive(m).and_return(:dummy)
      end
      tree = double('tree')
      tree.stub(current_activity: current_activity)
      described_class.new(tree)
    end

    it 'forwards some methods to the current activity' do
      Scorm2004::Sequencing::AbstractProcess::CURRENT_ACTIVITY_METHODS.each do |m|
        subject.send(m).should == :dummy
      end
    end
  end

  Scorm2004::Sequencing::ProcessFactory::ACTIVITY_TREE_PROCESSES.each do |m|
    describe "##{m}" do
      it 'instantiates the appropriate process class' do
        klass = double('ProcessFactory')
        klass.should_receive(:new).and_return("dummy process: #{m}")
        stub_const('Scorm2004::Sequencing::' + m.to_s.split('_').map(&:capitalize).join(''), klass)
        described_class.new(:dummy_activity_tree).send(m).should == "dummy process: #{m}"
      end
    end
  end

  describe '#set_current_activity' do
    it 'sets a current activity' do
      tree = double("activity tree")
      tree.should_receive(:current_activity=).with(:dummy_activity)
      proc = described_class.new(tree)
      proc.set_current_activity(:dummy_activity)
    end
  end
end
