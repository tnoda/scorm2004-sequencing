require 'spec_helper'
require 'scorm2004/sequencing/delivery_controls'

describe Scorm2004::Sequencing::DeliveryControls do
  subject do
    obj = double('activity')
    obj.extend(Scorm2004::Sequencing::DeliveryControls)
    obj
  end

  describe 'defaults' do
    before { subject.stub(:sequencing).and_return({}) }
    its(:tracked) { should be_true }
    its(:completion_set_by_content) { should be_false }
    its(:objective_set_by_content) { should be_false }
  end

  describe 'flipped defaults' do
    before do
      flipped = {
        'tracked' => false,
        'completion_set_by_content' => true,
        'objective_set_by_content' => true
      }
      subject.stub(:sequencing => { 'delivery_controls' => flipped } )
    end

    its(:tracked) { should be_false }
    its(:completion_set_by_content) { should be_true }
    its(:objective_set_by_content) { should be_true }
  end
end
