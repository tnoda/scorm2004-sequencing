require 'spec_helper'
require 'scorm2004/sequencing/activity_progress_rollup_using_measure_process'

describe Scorm2004::Sequencing::ActivityProgressRollupUsingMeasureProcess do
  shared_examples 'process' do |expected, amount, measure, completed_by_measure, amount_status|
    let(:activity) do
      a = double('activity')
      a.stub(
        :attempt_completion_amount => amount,
        :minimum_progress_measure => measure,
        :completed_by_measure => completed_by_measure || completed_by_measure.nil?,
        :attempt_completion_amount_status => amount_status || amount_status.nil?
        )
      a
    end

    it "sets Attempt Progress Status to #{expected[0]} and " +
      "Attempt Completion Status to #{expected[1]}" do
      activity.should_receive(:attempt_progress_status=).with(expected[0])
      activity.should_receive(:attempt_completion_status=).with(expected[1])
      subject.call(activity)
    end
  end

  [ [[false, false], nil, nil, false, false],
    [[false, false], nil, nil, false, true],
    [[false, false], nil, nil, true, false],
    [[true, false], 0.4, 0.6],
    [[true, true], 0.5, 0.5]
  ].each do |*args|
    it_behaves_like 'process', *args
  end
end
