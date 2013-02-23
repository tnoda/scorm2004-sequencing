require 'spec_helper'
require 'scorm2004/sequencing/sequencing_rule_condition'
require 'ostruct'

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

  describe Scorm2004::Sequencing::SequencingRuleCondition::SatisfiedEvaluator do
    shared_examples 'satisfied evaluator' do |prog, sat|
      it "returns #{prog && sat} against the referenced objective: " +
        "progress_status = #{prog}, satisfied_status = #{sat}" do
        o = double('referenced objective')
        o.stub(:progress_status => prog, :satisfied_status => sat, :id => 'obj123')
        a = double('activity')
        dummy_obj = OpenStruct.new
        a.stub(:objectives => [dummy_obj, dummy_obj, o, dummy_obj])
        c = double('rule condition')
        c.stub(:referenced_objective => 'obj123')
        Scorm2004::Sequencing::SequencingRuleCondition::SatisfiedEvaluator
          .new(c).call(a).should == (prog && sat)
      end
    end

    [true, false].repeated_permutation(2).each do |pair|
      it_behaves_like 'satisfied evaluator', *pair
    end
  end
end
