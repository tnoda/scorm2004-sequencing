require 'spec_helper'
require 'scorm2004/sequencing/sequencing_rule_condition'

describe Scorm2004::Sequencing::SequencingRuleCondition do
  describe 'Description' do
    context 'default values' do
      subject do
        described_class.new({})
      end

      it 'must have Rule Condition' do
        expect { subject.to_s }.to raise_error
      end
      its(:referenced_objective) { should be_nil }
      its(:measure_threshold) { should be_nil }
      its(:operator) { should == 'NO-OP' }
    end

    context 'example' do
      subject do
        described_class.new( {
            'referenced_objective' => 'OBJ123',
            'measure_threshold' => 0.8,
            'operator' => 'not',
            'condition' => 'objectiveMeasureGreaterThan'
          } )
      end

      its(:to_s) { should == 'Objective Measure Greater Than' }
      its(:referenced_objective) { should == 'OBJ123' }
      its(:measure_threshold) { should == 0.8 }
      its(:operator) { should == 'Not' }
    end
  end
end
