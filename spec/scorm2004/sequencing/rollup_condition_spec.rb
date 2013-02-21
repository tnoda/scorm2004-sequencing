require 'spec_helper'
require 'scorm2004/sequencing/rollup_condition'

describe Scorm2004::Sequencing::RollupCondition do
  shared_context '<rollupCondition>' do |cond, op|
    subject do
      rc = {}
      rc.merge!('condition' => cond) if cond
      rc.merge!('operator' => op) if op
      described_class.new(rc)
    end
  end

  shared_examples 'rollup rule' do |cond, op|
    describe "#rule_condition #= #{cond}" do
      its(:rule_condition) { should == cond }
    end if cond

    describe "#rule_condition_operator #= #{op}" do
      its(:rule_condition_operator) { should == op }
    end if op
  end

  describe '#rule_condition' do
    { 'never' => 'Never',
      'satisfied' => 'Satisfied',
      'objectiveStatusKnown' => 'Objective Status Known',
      'objectiveMeasureKnown' => 'Objective Measure Known',
      'completed' => 'Completed',
      'activityProgressKnown' => 'Activity Progress Known',
      'attempted' => 'Attempted',
      'attemptLimitExceeded' => 'Attempt Limit Exceeded'
    }.each do |cam, sn|
      it_behaves_like 'rollup rule', sn do
        include_context '<rollupCondition>', cam
      end
    end

    context 'default value' do
      its(:rule_condition) { should == 'Never' }
    end
  end

  describe '#condition_operator' do
    { 'noOp' => 'NO-OP',
      'not' => 'Not'
    }.each do |cam, sn|
      it_behaves_like 'rollup rule', 'Never', sn do
        include_context '<rollupCondition>', nil, cam
      end
    end

    context 'default value' do
      its(:rule_condition_operator) { should == 'NO-OP' }
    end
  end

  shared_context 'child with rolled-up objective' do |progress, satisfied, measure|
    let(:child) do
      ro = double('rolled-up objective')
      %w( progress satisfied measure).each do |t|
        flag = (eval(t) == true)
        ro.stub("#{t}_status".intern).and_return(flag) 
      end
      child = double('child')
      child.stub(:rolled_up_objective).and_return(ro)
      child
    end
  end

  shared_examples 'condition evaluator' do |expected|
    it "evaluates the condition and returns: #{expected}"  do
      subject.evaluate(child).should == expected
    end
  end

  shared_examples 'objective evaluator' do |cond, prog, sat, meas, expected|
    it_behaves_like 'condition evaluator', expected do
      include_context '<rollupCondition>', cond
      include_context 'child with rolled-up objective', prog, sat, meas
    end

    it_behaves_like 'condition evaluator', !expected do
      include_context '<rollupCondition>', cond, 'not'
      include_context 'child with rolled-up objective', prog, sat, meas
    end
  end

  shared_context 'child' do |prog, count, al_control, al|
    let(:child) do
      c = double('child')
      c.stub(:attempt_progress_status).and_return(prog || false)
      c.stub(:activity_attempt_count).and_return(count || 0)
      c.stub(:limit_condition_attempt_limit_control).and_return(al_control || false)
      c.stub(:limit_condition_attempt_limit).and_return(al)
      c
    end
  end

  shared_examples  'progress evaluator' do |cond, expected, prog, count, al_control, al|
    it_behaves_like 'condition evaluator', expected do
      include_context '<rollupCondition>', cond
      include_context 'child', prog, count, al_control, al
    end

    it_behaves_like 'condition evaluator', !expected do
      include_context '<rollupCondition>', cond, 'not'
      include_context 'child', prog, count, al_control, al
    end
  end

  describe '#evaluate' do
    [ ['satisfied', true, true, nil, true],
      ['satisfied', true, nil, nil, false],
      ['satisfied', nil, nil, nil, false],
      ['satisfied', nil, nil, nil, false],
      ['objectiveStatusKnown', true, nil, nil, true],
      ['objectiveStatusKnown', nil, nil, nil, false],
      ['objectiveMeasureKnown', nil, nil, true, true],
      ['objectiveMeasureKnown', nil, nil, false, false]
    ].each do |*args|
      it_behaves_like 'objective evaluator', *args
    end

    [ ['activityProgressKnown', true, true],
      ['activityProgressKnown', false],
      ['attempted', true, nil, 1],
      ['attempted', false],
      ['attemptLimitExceeded', true, true, 10, true, 3],
      ['attemptLimitExceeded', false, true, 1, true, 3],
      ['attemptLimitExceeded', false, true, 1, false]
    ].each do |*args|
      it_behaves_like 'progress evaluator', *args
    end

    it_behaves_like 'condition evaluator', false do
      include_context '<rollupCondition>', 'never'
      let(:child) { :dummy }
    end
  end
end
