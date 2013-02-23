require 'spec_helper'
require 'scorm2004/sequencing/activity_progress_rollup_using_rules_process'

describe Scorm2004::Sequencing::ActivityProgressRollupUsingRulesProcess do
  shared_examples 'process' do |subprocs, results|
    let(:activity) do
      p = double('RollupRuleCheckSubprocess')
      p.stub_chain(:new, :call) { subprocs.shift }
      stub_const('Scorm2004::Sequencing::RollupRuleCheckSubprocess', p)
      a = double('activity')
      results.each_slice(2) do |prog, comp|
        a.should_receive(:attempt_progress_status=).once.ordered.with(prog)
        a.should_receive(:attempt_completion_status=).once.ordered.with(comp)
      end
      a
    end

    it 'might update Attempt Progress Status and Attempt Completion Status' do
      subject.call(activity)
    end
  end

  [ [[true, true], [true, false, true, true]],
    [[true, false], [true, false]],
    [[false, true], [true, true]],
    [[false, false], []]
  ].each do |args|
    it_behaves_like 'process', *args
  end
end
