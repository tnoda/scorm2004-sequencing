require 'spec_helper'
require 'scorm2004/sequencing/rollup_controls'

describe Scorm2004::Sequencing::RollupControls do
  subject do
    a = double('activity')
    a.extend(Scorm2004::Sequencing::RollupControls)
    a
  end

  shared_examples 'rollup controls' do |ros, romw, rpc|
    its(:rollup_objective_satisfied) { should == ros }
    its(:rollup_objective_measure_weight) { should == romw }
    its(:rollup_progress_completion) { should == rpc }
  end

  describe 'defaults' do
    before { subject.stub(:rollup_rules).and_return({}) }
    it_behaves_like 'rollup controls', true, 0.0, true
  end

  describe 'example' do
    before do
      rules = {
        'rollup_objective_satisfied' => false,
        'rollup_objective_measure_weight' => 0.2,
        'rollup_progress_completion' => false
      }
      subject.stub(:rollup_rules).and_return(rules)
    end
    it_behaves_like 'rollup controls', false, 0.2, false
  end
end
