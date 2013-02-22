require 'spec_helper'
require 'scorm2004/sequencing/objective_rollup_using_rules_process'

describe Scorm2004::Sequencing::ObjectiveRollupUsingRulesProcess do
  context 'no rolled-up objective' do
    it 'does nothing' do
      a = double('activity')
      a.stub(:rolled_up_objective).and_return(nil)
      subject.call(a)
    end
  end

  shared_examples 'with a rolled-up objective' do |subprocs, results|
    it 'might update Objective Progress/Satisfied Status' do
      proc = double('RollupRuleCheckSubprocess')
      proc.stub_chain(:new, :call) { subprocs.shift }
      stub_const('Scorm2004::Sequencing::RollupRuleCheckSubprocess', proc)
      ro = double('rolled-up objective')
      results.each do |prog, sat|
        ro.should_receive(:progress_status=).once.ordered.with(prog)
        ro.should_receive(:satisfied_status=).once.ordered.with(sat)
      end
      a = double('activity')
      a.stub(:rolled_up_objective => ro)
      subject.call(a)
    end
  end

  [ [[true, true], [[true, false], [true, true]]],
    [[true, false], [[true, false]]],
    [[false, true], [[true, true]]],
    [[false, false], []]
  ].each do |*args|
    it_behaves_like 'with a rolled-up objective', *args
  end
end
