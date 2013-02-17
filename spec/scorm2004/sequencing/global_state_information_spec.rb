require 'spec_helper'
require 'scorm2004/sequencing/global_state_information'

describe Scorm2004::Sequencing::GlobalStateInformation do
  subject do
    obj = Object.new.extend(Scorm2004::Sequencing::GlobalStateInformation)
    obj.instance_variable_set(:@state, {})
    obj
  end

  describe 'defaults' do
    its(:current_activity) { should be_nil }
    its(:suspended_activity) { should be_nil }
  end

  describe 'example' do
    before do
      state = {
        'global_state_information' => {
          'current_activity' => 'foo',
          'suspended_activity' => 'bar'
        }
      }
      subject.instance_variable_set(:@state, state)
    end

    its(:current_activity) { should == 'foo' }
    its(:suspended_activity) { should == 'bar'}
    
    describe '#current_activity=' do
      it 'sets Current Activity' do
        expect {
          subject.current_activity = 'baz'
        }.to change {
          subject.current_activity
        }.from('foo').to('baz')
      end
    end

    describe '#suspended_activity=' do
      it 'sets Suspended Activity' do
        expect {
          subject.suspended_activity = 'baz'
        }.to change {
          subject.suspended_activity
        }.from('bar').to('baz')
      end
    end
  end
end
