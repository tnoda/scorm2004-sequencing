require 'spec_helper'
require 'scorm2004/sequencing/rollup_rule_description'

describe Scorm2004::Sequencing::RollupRuleDescription do
  subject do
    r = double('rollup rule')
    r.extend(Scorm2004::Sequencing::RollupRuleDescription)
    r
  end

  shared_context 'rollup rule attributes' do |action, combi, set, min_percent, min_count|
    let(:rule) do
      { "child_activity_set" => set,
        "minimum_count" => min_count,
        "minimum_percent" => min_percent,
        "rollup_conditions" => { "condition_combination" => combi },
        "rollup_action" => { "action" => action }
      }
    end
  end

  shared_examples 'rollup rule' do |action, combi, set, min_percent, min_count, conditions|
    before { subject.stub(:rule).and_return(rule) }
    its(:action) { should == action }
    its(:condition_combination) { should == combi}
    its(:child_activity_set) { should == set }
    its(:minimum_percent) { should == min_percent }
    its(:minimum_count) { should == min_count }
    its(:conditions) { should == conditions } if conditions
  end

  describe 'defaults' do
    it_behaves_like 'rollup rule', 'Satisfied', 'Any', 'All', 0.0, 0, [] do
      let(:rule) { {} }
    end
  end

  describe 'example without conditions' do
    it_behaves_like 'rollup rule', 'Completed', 'All', 'At Least Count', 0.5, 3, [] do
      include_context 'rollup rule attributes', 'completed', 'All', 'atLeastCount', 0.5, 3
    end
  end
end
