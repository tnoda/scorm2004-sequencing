require 'spec_helper'
require 'scorm2004/sequencing/rollup_rules'

describe Scorm2004::Sequencing::RollupRules do
  subject do
    a = double('activity')
    a.extend(Scorm2004::Sequencing::RollupRules)
    a
  end

  shared_examples '#rollup_rules' do |n, *args|
    it "finds rollup rules that have specified rollup activities: #{args}" do
      def fake_rollup_rule(rollup_action)
        { 'rollup_action' => { 'action' => rollup_action} }
      end
      rollup_actions = ['satisfied', 'satisfied', 'notSatisfied', 'completed']
      item = {
        'rollup_rules' => { 'rollup_rules' =>
          rollup_actions.map { |a| fake_rollup_rule(a) }
        }
      }
      subject.stub(:item => item)
      subject.rollup_rules(*args).should have(n).rollup_rules
    end
  end

  it_behaves_like '#rollup_rules', 4
  it_behaves_like '#rollup_rules', 2, 'Satisfied'
  it_behaves_like '#rollup_rules', 3, 'Satisfied', 'Not Satisfied'
end
