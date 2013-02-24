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

  shared_context 'rule condition' do |measure_threshold|
    let(:rule_condition) do
      c = double('rule condition')
      c.stub(:referenced_objective => 'obj123',
        :measure_threshold => measure_threshold)
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

  describe Scorm2004::Sequencing::SequencingRuleCondition::ObjectiveMeasureGreaterThanEvaluator do
    shared_examples 'objective measure greater than evaluator' do |ref, ms, nm, mt|
      include_context 'rule condition', mt
      include_context 'activity with referenced objective', ref, nil, nil, ms, nm

      it "returns #{ref && ms && nm > mt} against the referenced objective: " +
        "exists = #{ref}, measure_status = #{ms}, normalized_measure = #{nm}; " +
        "measure_threshold = #{mt}" do
        Scorm2004::Sequencing::SequencingRuleCondition::ObjectiveMeasureGreaterThanEvaluator
          .new(rule_condition).call(activity).should == (ref && ms && nm > mt)
      end
    end

    [true, false].repeated_permutation(2).map { |pair0|
      [0.3, 0.7].repeated_permutation(2).map { |pair1|
        pair0 + pair1
      }
    }.flatten(1).each do |pair|
      it_behaves_like 'objective measure greater than evaluator', *pair
    end
  end

  describe Scorm2004::Sequencing::SequencingRuleCondition::ObjectiveMeasureLessThanEvaluator do
    shared_examples 'objective measure less than evaluator' do |ref, ms, nm, mt|
      include_context 'rule condition', mt
      include_context 'activity with referenced objective', ref, nil, nil, ms, nm

      it "returns #{ref && ms && nm < mt} against the referenced objective: " +
        "exists = #{ref}, measure_status = #{ms}, normalized_measure = #{nm}; " +
        "measure_threshold = #{mt}" do
        Scorm2004::Sequencing::SequencingRuleCondition::ObjectiveMeasureLessThanEvaluator
          .new(rule_condition).call(activity).should == (ref && ms && nm > mt)
      end
    end

    [true, false].repeated_permutation(2).map { |pair0|
      [0.3, 0.7].repeated_permutation(2).map { |pair1|
        pair0 + pair1
      }
    }.flatten(1).each do |pair|
      it_behaves_like 'objective measure greater than evaluator', *pair
    end
  end

  shared_context 'activity' do |prog, comp, count, lcal_control, lcal|
    let(:activity) do
      a = double('activity')
      a.stub(:attempt_progress_status => prog,
        :attempt_completion_status => comp,
        :activity_attempt_count => count,
        :limit_condition_attempt_limit_control => lcal_control,
        :limit_condition_attempt_limit => lcal)
      a
    end
  end

  describe Scorm2004::Sequencing::SequencingRuleCondition::CompletedEvaluator do
    shared_examples 'completed evaluator' do |prog, comp|
      include_context 'rule condition'
      include_context 'activity', prog, comp

      it "returns #{prog && comp} against the activity: " +
        "progress_status = #{prog}, satisfied_status = #{comp}" do
        Scorm2004::Sequencing::SequencingRuleCondition::CompletedEvaluator
          .new(rule_condition).call(activity).should == (prog && comp)
      end
    end

    [true, false].repeated_permutation(2).each do |pair|
      it_behaves_like 'completed evaluator', *pair
    end
  end

  describe Scorm2004::Sequencing::SequencingRuleCondition::ActivityProgressKnownEvaluator do
    shared_examples 'activity progress known evaluator' do |prog|
      include_context 'rule condition'
      include_context 'activity', prog

      it "returns #{prog} against the activity: " +
        "progress_status = #{prog}" do
        Scorm2004::Sequencing::SequencingRuleCondition::ActivityProgressKnownEvaluator
          .new(rule_condition).call(activity).should == prog
      end
    end

    [true, false].each do |prog|
      it_behaves_like 'completed evaluator', prog
    end
  end

  describe Scorm2004::Sequencing::SequencingRuleCondition::AttemptedEvaluator do
    shared_examples 'attempted evaluator' do |count|
      include_context 'rule condition'
      include_context 'activity', nil, nil, count

      it "returns #{count > 0} against the activity: " +
        "activity_attempt_count: #{count}" do
        Scorm2004::Sequencing::SequencingRuleCondition::AttemptedEvaluator
          .new(rule_condition).call(activity).should == (count > 0)
      end
    end

    [0, 1].each do |count|
      it_behaves_like 'attempted evaluator', count
    end
  end

  describe Scorm2004::Sequencing::SequencingRuleCondition::AttemptLimitExceededEvaluator do
    shared_examples 'attempt limit exceeded evaluator' do |prof, count, lcal_control, lcal|
      include_context 'rule condition'
      include_context 'activity', prog, nil, count, lcal_control, lcal

      it "returns #{lcal_control && count >= lcal } against the activity: " +
        "activity_attempt_count = #{count}, " +
        "limit_condition_attempt_limit_control = #{lcal_control}, " +
        "limit_condition_attempt_limit = #{lcal}" do
        Scorm2004::Sequencing::SequencingRuleCondition::AttemptLimitExceededEvaluator
          .new(rule_condition).call(activity).should == (lcal_control && count >= lcal)
      end
    end

    [true, false].repeated_permutation(2).map do |pair0|
      [1, 2].repeated_permutation(2).map do |pair1|
        [pair0, pair1].transpose.flatten.each do |args|
          it_behaves_like 'completed evaluator', *args
        end
      end
    end
  end
end
