require 'spec_helper'
require 'scorm2004/sequencing/sequencing_rule'

describe Scorm2004::Sequencing::SequencingRule do
  describe 'Description' do
    context 'default values' do
      subject do
        described_class.new({'rule_conditions' => {}})
      end

      its(:condition_combination) { should == 'All' }
      its(:rule_conditions) { should be_empty }
      its(:rule_action) { should be_empty }
    end

    context 'example' do
      subject do
        described_class.new( {
            'rule_conditions' => {
              'condition_combination' => 'any',
              'rule_conditions' => [ {}, {}]
            },
            'rule_action' => { 'action' => 'stopForwardTraversal' }
          } )
      end

      its(:condition_combination) { should == 'Any'}
      its(:conditions) { should have(2).rule_conditions }
      its(:rule_action) { should == 'Stop Forward Traversal'}
    end
  end
end
