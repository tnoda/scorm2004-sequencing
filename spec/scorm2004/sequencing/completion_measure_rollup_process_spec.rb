require 'spec_helper'
require 'scorm2004/sequencing/completion_measure_rollup_process'

describe Scorm2004::Sequencing::CompletionMeasureRollupProcess do
  let(:activity) { double('activity')}

  shared_examples 'completion measure rollup process' do |amount_status, amount|
    it 'might set Attempt Completion Amount Status and/or Attempt Completion Amount' do
      unless amount_status.nil?
        activity.should_receive(:attempt_completion_amount_status=).with(amount_status)
      end

      if amount
        activity.should_receive(:attempt_completion_amount=).with(amount)
      end

      activity.stub(:children).and_return(children)
      subject.call(activity)
    end
  end

  def mock_child(id, tracked = false, progress_weight = 1.0, amount_status = false, amount = 0.0)
    c = double('child-' + id)
    c.stub(:tracked?).and_return(tracked)
    c.stub(:progress_weight).and_return(progress_weight)
    c.stub(:attempt_completion_amount_status).and_return(amount_status)
    c.stub(:attempt_completion_amount).and_return(amount)
    c
  end

  context 'without children' do
    let(:children) { [] }
    it_behaves_like 'completion measure rollup process', false
  end

  context 'with children not tracked' do
    let(:children) { [ mock_child('c0'), mock_child('c0', false, 1.0, true, 1.0)] }
    it_behaves_like 'completion measure rollup process', false
  end

  context 'with children whose Attempt Completion Amount Status is false' do
    let(:children) do
      [ mock_child('c0', true, 1.0, false), mock_child('c1', true, 1.0, false, 1.0)]
    end
    it_behaves_like 'completion measure rollup process', false
  end

  context 'with some children' do
    let(:children) do
      [ mock_child('c0', true, 0.2, true, 0.9),
        mock_child('c1', true, 0.3, true, 0.8),
        mock_child('c2', true, 0.5, true, 0.7)
      ]
    end
    it_behaves_like 'completion measure rollup process', true, 0.77
  end
end
