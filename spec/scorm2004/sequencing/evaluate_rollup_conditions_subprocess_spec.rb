require 'spec_helper'
require 'scorm2004/sequencing/evaluate_rollup_conditions_subprocess'

describe Scorm2004::Sequencing::EvaluateRollupConditionsSubprocess do
  shared_context 'rollup rule' do |combi, conds|
    let(:proc) do
      rule = double('rollup rule')
      rule.stub(:condition_combination).and_return(combi)
      conditions = conds.map do |cond|
        c = double
        c.stub(:evaluate).and_return(cond)
        c
      end
      rule.stub(:conditions).and_return(conditions)
      described_class.new(rule)
    end
  end

  shared_examples 'process' do |expect, combi, conds|
    context "using conditions that result in #{conds} and #{combi} Condition Combination" do
      include_context 'rollup rule', combi, conds
      it "returns #{expect}" do
        proc.call(:dummy_activity).should == expect
    end

    end
  end

  [ [nil, 'All', []],
    [nil, 'Any', []],
    [true, 'All', [true, true, true]],
    [true, 'Any', [false, true, false]],
    [false, 'All', [true, true, false]],
    [false, 'Any', [false, false, false]]
  ].each do |*args|
    it_behaves_like 'process', *args
  end
end
