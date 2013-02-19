require 'spec_helper'
require 'scorm2004/sequencing/objectives'

describe Scorm2004::Sequencing::Objectives do
  subject do
    a = double('activity')
    a.extend(Scorm2004::Sequencing::Objectives)
    a
  end

  describe 'defaults' do
    before { subject.stub(:sequencing).and_return({}) }
    its(:objectives) { should be_empty }
    its(:primary_objective) { should be_nil }
  end

  describe 'example' do
    before do
      sequencing = {
        'objectives' => {
          'primary_objective' => {
            'objective_id' => 'obj_p'
          },
          'objectives' => [
              { 'objective_id' => 'obj_s0' },
              { 'objective_id' => 'obj_s1' }
          ]
        }
      }
      subject.stub(:sequencing).and_return(sequencing)
      subject.stub(:status).and_return(:dummy)
    end

    its(:rolled_up_objective) do
      should be_an(Scorm2004::Sequencing::Objective)
    end
    its(:objectives) { should have(3).objectives }
    its('objectives.first.id') { should == 'obj_p' }
    its('objectives.last') do
      should be_an(Scorm2004::Sequencing::Objective)
    end
    its('objectives.last.id') { should == 'obj_s1' }
  end
end
