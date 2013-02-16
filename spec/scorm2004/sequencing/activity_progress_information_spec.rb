require 'spec_helper'
require 'scorm2004/sequencing/activity_progress_information'

describe Scorm2004::Sequencing::ActivityProgressInformation do
  subject do
    obj = Object.new.extend(Scorm2004::Sequencing::ActivityProgressInformation)
    obj.instance_eval do
      @identifier = 'example'
      @state = {}
    end
    obj
  end


  describe 'defaults' do
    its(:activity_progress_status) { should == false }
    its(:activity_absolute_duration) { should == 0.0 }
    its(:activity_experienced_duration) { should == 0.0 }
    its(:activity_attempt_count) { should == 0 }
  end

  describe 'example' do
    before do
      subject.instance_eval do
        @state = {
          'activities' => {
            'example' => {
              'activity_progress_information' => {
                'activity_progress_status' => true,
                'activity_absolute_duration' => 123.4,
                'activity_experienced_duration' => 12.3,
                'activity_attempt_count' => 3
              }
            }
          }
        }
      end
    end

    its(:activity_progress_status) { should be_true }
    its(:activity_absolute_duration) { should == 123.4 }
    its(:activity_experienced_duration) { should == 12.3 }
    its(:activity_attempt_count) { should == 3 }

    describe '#activity_progress_status=' do
      it 'sets Activity Progress Status' do
        expect {
          subject.activity_progress_status = false
        }.to change {
          subject.activity_progress_status
        }.from(true).to(false)
      end
    end

    describe '#activity_absolute_duration=' do
      it 'sets Activity Absolute Duration' do
        expect {
          subject.activity_absolute_duration= 567.8
        }.to change {
          subject.activity_absolute_duration
        }.from(123.4).to(567.8)
      end
    end

    describe '#activity_experienced_duration=' do
      it 'sets Activity Experienced Duration' do
        expect {
          subject.activity_experienced_duration= 45.6
        }.to change {
          subject.activity_experienced_duration
        }.from(12.3).to(45.6)
      end
    end

    describe '#activity_attempt_count=' do
      it 'sets Activity Attempt Count' do
        expect {
          subject.activity_attempt_count = 4
        }.to change {
          subject.activity_attempt_count
        }.from(3).to(4)
      end
    end
  end
end
