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

  shared_context 'activity with referenced objective' do |ref, prog, sat, ms, nm|
    let(:activity) do
      o = double('referenced objective')
      o.stub( :id => 'obj123',
        :progress_status => prog, :satisfied_status => sat,
        :measure_status => ms, :normalized_measure => nm)
      a = double('activity')
      objectives = Array.new(4, OpenStruct.new)
      objectives << o if ref
      a.stub(:objectives => objectives)
      a
    end
  end

  shared_context 'rule condition' do
    let(:rule_condition) do
      c = double('rule condition')
      c.stub(:referenced_objective => 'obj123')
      c
    end
  end

  describe Scorm2004::Sequencing::SequencingRuleCondition::SatisfiedEvaluator do
    shared_examples 'satisfied evaluator' do |ref, prog, sat|
      include_context 'rule condition'
      include_context 'activity with referenced objective', ref, prog, sat

      it "returns #{ref && prog && sat} against the referenced objective: " +
        "exists = #{ref}, progress_status = #{prog}, satisfied_status = #{sat}" do
        Scorm2004::Sequencing::SequencingRuleCondition::SatisfiedEvaluator
          .new(rule_condition).call(activity).should == (ref && prog && sat)
      end
    end

    [true, false].repeated_permutation(3).each do |pair|
      it_behaves_like 'satisfied evaluator', *pair
    end
  end

  describe Scorm2004::Sequencing::SequencingRuleCondition::ObjectiveStatusKnownEvaluator do
    shared_examples 'objective status known evaluator' do |ref, prog|
      include_context 'rule condition'
      include_context 'activity with referenced objective', ref, prog

      it "returns #{ref && prog} against the referenced objective: " +
        "exists = #{ref}, progress_status = #{prog}" do
        Scorm2004::Sequencing::SequencingRuleCondition::ObjectiveStatusKnownEvaluator
          .new(rule_condition).call(activity).should == (ref && prog)
      end
    end

    [true, false].repeated_permutation(2).each do |pair|
      it_behaves_like 'objective status known evaluator', *pair
    end
  end

  describe Scorm2004::Sequencing::SequencingRuleCondition::ObjectiveMeasureKnownEvaluator do
    shared_examples 'objective measure known evaluator' do |ref, measure_status|
      include_context 'rule condition'
      include_context 'activity with referenced objective', ref, nil, nil, measure_status

      it "returns #{ref && measure_status} against the referenced objective: " +
        "exists = #{ref}, measure_status = #{measure_status}" do
        Scorm2004::Sequencing::SequencingRuleCondition::ObjectiveMeasureKnownEvaluator
        .new(rule_condition).call(activity).should == (ref && measure_status)
      end
    end

    [true, false].repeated_permutation(2).each do |pair|
      it_behaves_like 'objective measure known evaluator', *pair
    end
  end
end
