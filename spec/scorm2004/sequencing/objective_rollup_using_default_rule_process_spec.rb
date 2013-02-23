require 'spec_helper'
require 'scorm2004/sequencing/objective_rollup_using_default_rule_process'

describe Scorm2004::Sequencing::ObjectiveRollupUsingDefaultRuleProcess do
  context 'without a rolled-up objective' do
    let(:activity) do
      a = double('activity')
      a.stub(:rolled_up_objective).and_return(nil)
      a
    end

    it 'does nothing' do
      subject.call(activity)
    end
  end

  shared_examples 'default rule' do |expected, children|
    def fake_child(rolled_up_objective = nil, tracked_flag = true, included_flag = true)
      c = double('child')
      c.stub(:tracked? => tracked_flag, :included_in_rollup? => included_flag)
      if rolled_up_objective
        ro = double('rolled-up objective')
        ro.stub(rolled_up_objective)
        c.stub(:rolled_up_objective => ro)
      end
      c
    end

    context "activity has children: #{children}" do
      let(:activity) do
        a = double('activity')
        a.stub(:children => children.map { |c| fake_child(*c)} )
        a
      end

      it "might update Objective Progress/Satisfied with #{expected}" do
        ro = double('activity rolled-up objective')
        expected.each_slice(2) do |prog, sat|
          ro.should_receive(:progress_status=).once.ordered.with(prog)
          ro.should_receive(:satisfied_status=).once.ordered.with(sat)
        end
        activity.stub(:rolled_up_objective => ro)
        subject.call(activity)
      end
    end
  end

  [ [[], [[nil, false, false], [nil, false, true]]],
    [[], [[nil, true, false]]],
    [[], [[{:progress_status => false}]]],
    [[true, false],
      [[{:progress_status => true, :satisfied_status => false },
          {:progress_status => true, :satisfied_status => true }]]],
    [[true, false, true, true],
      [[{:progress_status => true, :satisfied_status => true},
          {:progress_status => true, :satisfied_status => true}]]]
  ].each do |*args|
    it_behaves_like 'default rule', *args
  end
end
