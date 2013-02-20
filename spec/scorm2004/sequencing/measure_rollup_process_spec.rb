require 'spec_helper'
require 'scorm2004/sequencing/measure_rollup_process'

describe Scorm2004::Sequencing::MeasureRollupProcess do
  let(:activity) { double('activity') }

  def mock_child(id, tracked,
      rolled_up_objective = nil, measure_status = false,
      measure_weight = 0.0, normalized_measure = 0.0)
    c = double('child-' + id)
    c.stub(:tracked?).and_return(tracked)
    c.stub(:rollup_objective_measure_weight).and_return(measure_weight)
    ro =  if rolled_up_objective
            obj = double("child-#{id}: rolled-up objective")
            obj.stub(:measure_status).and_return(measure_status)
            obj.stub(:normalized_measure).and_return(normalized_measure)
            obj
          end
    c.stub(:rolled_up_objective).and_return(ro)
    c
  end

  shared_examples 'measure rollup process' do |status, measure|
    it 'sets Objective Measure Status and/or Objective Normalized Measure' do
      ro = double('rolled-up objective')
      unless status.nil?
        ro.should_receive(:measure_status=).with(status)
      end
      if measure
        ro.should_receive(:normalized_measure=).with(measure)
      end
      activity.stub(:rolled_up_objective).and_return(ro)
      subject.call(activity)
    end
  end

  context 'without a rolled-up objective' do
    before { activity.stub(:rolled_up_objective).and_return(nil) }
    it 'does nothing' do
      subject.call(activity)
    end
  end


  context 'with children not tracked' do
    before do
      c0 = mock_child('c0', false)
      c1 = mock_child('c0', false, true, true, 0.3, 0.5)
      activity.stub(:children).and_return([c0, c1])
    end

    it_behaves_like 'measure rollup process', false, nil
  end

  context 'with children tracked but not contribute to the rollup' do
    before do
      c0 = mock_child('c0', true, false)
      c1 = mock_child('c1', true, false, true, 0.4, 0.6)
      activity.stub(:children).and_return([c0])
    end

    it_behaves_like 'measure rollup process', false, nil
  end

  context 'with children whose rolled-up objective has false Objective Measure Status' do
    before do
      c0 = mock_child('c0', true, true)
      c1 = mock_child('c1', true, true, false, 0.2, 0.4)
      activity.stub(:children).and_return([c0, c1])
    end

    it_behaves_like 'measure rollup process', false, nil
  end

  context 'examle' do
    before do
      c0 = mock_child('c0', true, true, true, 0.2, 0.6)
      c1 = mock_child('c1', true, true, true, 0.3, 0.7)
      c2 = mock_child('c2', true, true, true, 0.5, 0.8)
      activity.stub(:children).and_return([c0, c1, c2])
    end

    it_behaves_like 'measure rollup process', true, 0.73
  end
end
