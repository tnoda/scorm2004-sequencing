require 'spec_helper'
require 'scorm2004/sequencing/limit_conditions'

describe Scorm2004::Sequencing::LimitConditions do
  subject do
    a = double('activity')
    a.extend(Scorm2004::Sequencing::LimitConditions)
    a
  end

  shared_context '<limitConditions>' do |l, adl|
    before do
      lc = {}                   # limit conditions default
      lc.merge!('attemptLimit' => l) unless l.nil?
      lc.merge!('attemptAbsoluteDurationLimit' => adl) unless adl.nil?
      subject.stub(:sequencing).and_return('limit_conditions' => lc)
    end
  end

  shared_examples 'limit conditions' do |alc, al, aadc, aadl|
    its(:limit_condition_attempt_limit_control) { should == alc }
    its(:limit_condition_attempt_limit) { should == al }
    its(:limit_condition_attempt_absolute_duration_control) { should == aadc }
    its(:limit_condition_attempt_absolute_duration_limit) { should == aadl }
  end

  it_behaves_like 'limit conditions', false, nil, false, nil do
    before { subject.stub(:sequencing).and_return({}) }
  end

  it_behaves_like 'limit conditions', true, 3, false, nil do
    include_context '<limitConditions>', 3
  end

  it_behaves_like 'limit conditions', false, nil, true, 'dummy duration' do
    include_context '<limitConditions>', nil, 'dummy duration'
  end

  it_behaves_like 'limit conditions', true, 4, true, 'dummy duration' do
    include_context '<limitConditions>', 4, 'dummy duration'
  end
end
