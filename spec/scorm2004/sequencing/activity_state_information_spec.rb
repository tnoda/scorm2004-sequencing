require 'spec_helper'
require 'scorm2004/sequencing/activity_state_information'

describe Scorm2004::Sequencing::ActivityStateInformation do
  subject do
    obj = Object.new.extend(Scorm2004::Sequencing::ActivityStateInformation)
    obj.instance_eval do
      @identifier = 'example'
      @state = {}
    end
    obj
  end

  describe 'defaults' do
    its(:activity_is_active) { should be_false }
    its(:activity_is_suspended) { should be_false }

    context 'for a leaf activity' do
      before { subject.stub(:children).and_return([]) }
      its(:available_children) { should be_empty }
    end

    context 'for a cluster activity' do
      before do
        children = %w( foo bar baz ).map do |identifier|
          c = double(identifier)
          c.stub(:identifier).and_return(identifier)
          c
        end
        subject.stub(:children).and_return(children)
      end

      its(:available_children) { should == %w( foo bar baz ) }
    end
  end

  describe 'example' do
    before do
      subject.instance_eval do
        @state = {
          'activities' => {
            @identifier => {
              'activity_state_information' => {
                'activity_is_active' => true,
                'activity_is_suspended' => true,
                'available_children' => %w( foo bar baz )
              }
            }
          }
        }
      end
    end

    its(:activity_is_active) { should be_true }
    its(:activity_is_suspended) { should be_true }
    its(:available_children) { should == %w( foo bar baz ) }

    describe '#activity_is_active=' do
      it 'sets Activity is Active' do
        expect {
          subject.activity_is_active = false
        }.to change {
          subject.activity_is_active
        }.from(true).to(false)
      end
    end

    describe '#activity_is_suspended=' do
      it 'sets Activity is suspended' do
        expect {
          subject.activity_is_suspended = false
        }.to change {
          subject.activity_is_suspended
        }.from(true).to(false)
      end
    end

    describe '#available_children=' do
      it 'sets Available Children' do
        expect {
          subject.available_children = %w( foo bar )
        }.to change {
          subject.available_children
        }.from(%w( foo bar baz )).to(%w( foo bar ))
      end
    end
  end
end
