require 'spec_helper'
require 'scorm2004/sequencing/sequencing_rule_check_subprocess'

shared_context 'sequencing rule' do |combi, results|
  let(:sequencing_rule) do
    conditions = results.map { |flag|
      c = double('rule condition')
      c.should_receive(:evaluate).and_return(flag)
      c
    }
    r = double('sequencing rule')
    r.stub(:rule_conditions => conditions, :condition_combination => combi)
    r
  end
end

shared_examples 'sequencing rule check subprocess' do |expected, combi, results|
  include_context 'sequencing rule', combi, results

  it "returns #{expected} against combination: #{combi}, results: #{results}" do
    described_class.new(sequencing_rule).call(:dummy).should == expected
  end
end

describe Scorm2004::Sequencing::SequencingRuleCheckSubprocess do
  [ [nil, 'All', []],
    [nil, 'Any', []],
    [true, 'All', [true, true]],
    [true, 'Any', [true, true]],
    [false, 'All', [true, false]],
    [true, 'Any', [true, false]],
    [false, 'All', [false, false]],
    [false, 'Any', [false, false]]
  ].each do |args|
    it_behaves_like 'sequencing rule check subprocess', *args
  end
end
