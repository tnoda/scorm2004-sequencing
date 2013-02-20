require 'spec_helper'
require 'scorm2004/sequencing/rollup_consideration_controls'

describe Scorm2004::Sequencing::RollupConsiderationControls do
  subject do
    a = double('activity')
    a.extend(Scorm2004::Sequencing::RollupConsiderationControls)
    a
  end

  shared_examples 'rollup consideration controls' do |*args|
    its(:measure_satisfaction_if_active) { should == args[0] }
    its(:required_for_satisfied) { should == args[1] }
    its(:required_for_not_satisfied) { should == args[2] }
    its(:required_for_completed) { should == args[3] }
    its(:required_for_incomplete) { should == args[4] }
  end

  describe 'defaults' do
    before { subject.stub(:sequencing).and_return({}) }
    it_behaves_like 'rollup consideration controls', true, 'always', 'always', 'always', 'always'
  end

  describe 'example' do
    before do
      s = {
        'rollup_considerations' => {
          'measure_satisfaction_if_active' => false,
          'required_for_satisfied' => 'always',
          'required_for_not_satisfied' => 'ifAttempted',
          'required_for_completed' => 'ifNotSkipped',
          'required_for_incomplete' => 'ifNotSuspended'
        }
      }
      subject.stub(:sequencing).and_return(s)
    end

    it_behaves_like 'rollup consideration controls', false, 'always', 'ifAttempted', 'ifNotSkipped', 'ifNotSuspended'
  end
end
