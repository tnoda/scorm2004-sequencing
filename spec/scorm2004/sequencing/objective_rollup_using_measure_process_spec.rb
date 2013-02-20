require 'spec_helper'
require 'scorm2004/sequencing/objective_rollup_using_measure_process'

describe Scorm2004::Sequencing::ObjectiveRollupUsingMeasureProcess do
  let(:activity) { double('activity') }
  let(:rolled_up_objective) { double('rolled-up objective') }

  shared_examples 'nothing' do
    it 'does nothing' do
      subject.call(activity)
    end
  end

  context 'without a rolled-up objective' do
    before { activity.stub(:rolled_up_objective).and_return(nil) }
    it_behaves_like 'nothing'
  end

  context 'with a rolled-up objective whose Objective Satisfied by Measure is false' do
    before do
      rolled_up_objective.stub(:satisfied_by_measure).and_return(false)
      activity.stub(:rolled_up_objective).and_return(rolled_up_objective)
    end

    it_behaves_like 'nothing'
  end

  shared_examples 'objective rollup using measure' do |ps, ss|
    it 'updates Objective Progress Status and/or Objective Satisfied Status' do
      rolled_up_objective.instance_eval do
        should_receive(:progress_status=).with(ps) unless ps.nil?
        should_receive(:satisfied_status=).with(ss) unless ss.nil?
      end
      subject.call(activity)
    end
  end

  context 'with a rolled-up objective whose Objective Measure Status is false' do
    before do
      rolled_up_objective.instance_eval do
        stub(:satisfied_by_measure).and_return(true)
        stub(:measure_status).and_return(false)
      end
      activity.stub(:rolled_up_objective).and_return(rolled_up_objective)
    end

    it_behaves_like 'objective rollup using measure', false, nil
  end

  shared_context 'Objective Measure Status is true' do |active, msia, nm, msnm|
    before do
      activity.stub(:active?).and_return(active)
      activity.stub(:measure_satisfaction_if_active).and_return(msia)
      rolled_up_objective.instance_eval do
        stub(:satisfied_by_measure).and_return(true)
        stub(:measure_status).and_return(true)
        stub(:normalized_measure).and_return(nm)
        stub(:minimum_satisfied_normalized_measure).and_return(msnm)
      end
      activity.stub(:rolled_up_objective).and_return(rolled_up_objective)
    end
  end

  it_behaves_like 'objective rollup using measure', false, nil do
    include_context 'Objective Measure Status is true', true, false
  end

  it_behaves_like 'objective rollup using measure', true, true do
    include_context  'Objective Measure Status is true', true, true, 0.6, 0.5
  end

  it_behaves_like 'objective rollup using measure', true, false do
    include_context  'Objective Measure Status is true', true, true, 0.6, 0.8
  end

  it_behaves_like 'objective rollup using measure', true, true do
    include_context  'Objective Measure Status is true', false, nil, 0.6, 0.4
  end

  it_behaves_like 'objective rollup using measure', true, false do
    include_context  'Objective Measure Status is true', false, nil, 0.6, 0.9
  end
end
