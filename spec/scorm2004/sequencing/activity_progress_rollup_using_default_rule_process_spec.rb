require 'spec_helper'
require 'scorm2004/sequencing/activity_progress_rollup_using_default_rule_process'

describe Scorm2004::Sequencing::ActivityProgressRollupUsingDefaultRuleProcess do
  shared_examples 'process' do |expected, children|
    def fake_child(progress_status, completion_status, tracked = true, included_in_rollup = true)
      c = double('child')
      c.stub(:attempt_progress_status => progress_status)
      c.stub(:attempt_completion_status => completion_status)
      c.stub(:tracked? => tracked)
      c.stub(:included_in_rollup? => included_in_rollup)
      c
    end

    let(:activity) do
      a = double('activity')
      expected.each_slice(2) do |prog, comp|
        a.should_receive(:attempt_progress_status=).once.ordered.with(prog)
        a.should_receive(:attempt_completion_status=).once.ordered.with(comp)
      end
      a.stub(:children => children.map { |c| fake_child(*c) } )
      a
    end

    it 'updates Attempt Progress Status and Attempt Completion Status' do
      subject.call(activity)
    end
  end

  [ [[], []],
    [[], [[false, false], [true, true]]],
    [[true, false], [[true, true], [true, false]]],
    [[true, false, true, true], [[true, true], [true, true]]]
  ].each do |args|
    it_behaves_like 'process', *args
  end
end
