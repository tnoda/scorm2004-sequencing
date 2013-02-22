require 'spec_helper'
require 'scorm2004/sequencing/rollup_rule_check_subprocess'

describe Scorm2004::Sequencing::RollupRuleCheckSubprocess do
  shared_context 'activity' do |rollup_rules, children|
    def fake_rollup_rule(results, child_activity_set = 'All', min_count = nil, min_percent = nil)
      rr = double('rollup rule')
      dr = results.dup
      rr.stub(:evaluate) { dr.shift }
      rr.stub(:child_activity_set).and_return(child_activity_set)
      rr.stub(:minimum_count).and_return(min_count)
      rr.stub(:minimum_percent).and_return(min_percent)
      rr
    end

    def fake_child(tracked = true, included_in_rollup = true)
      c = double('child')
      c.stub(:tracked? => tracked, :included_in_rollup? => included_in_rollup)
      c
    end

    let(:activity) do
      a = double('activity')
      a.stub(:rollup_rules => rollup_rules.map { |r| fake_rollup_rule(*r) } )
      a.stub(:children => children.map { |c| fake_child(*c) } )
      a
    end
  end


  shared_examples 'rollup rule check subprocess' do |expected, rollup_rules, children|
    include_context 'activity', rollup_rules, children
    it "checks the rollup rule for the activity: #{expected}; #{rollup_rules}; #{children}" do
      subject.call(activity, :dummy).should == expected
    end
  end

  [ [false, [], []],
    [true,  [[[true, true]]], [[], []]],
    [false, [[[true, true, false]]], [[], [], []]],
    [false, [[[true, true]]], [[false, false], [false, true]]],
    [false, [[[true, true]]], [[true, false], [true, false]]],
    [true,  [[[true, true, false], 'Any']], [[], [], []]],
    [false, [[[true, true, false], 'None']], [[], [], []]],
    [false, [[[false, nil, false], 'None']], [[], [], []]],
    [true,  [[[false, false, false], 'None']], [[], [], []]],
    [true,  [[[true, true, false]], [[true, true, true]]], [[], [], []]],
    [true,  [[[true, true, true, false], 'At Least Count', 3]], [[], [], [], []]],
    [false, [[[true, true, false, false], 'At Least Count', 3]], [[], [], [], []]],
    [true,  [[[true, true, true, false], 'At Least Percent', nil, 0.75]], [[], [], [], []]],
    [false, [[[true, true, false, false], 'At Least Percent', nil, 0.75]], [[], [], [], []]]
  ].each do |*args|
    it_behaves_like 'rollup rule check subprocess', *args
  end
end
