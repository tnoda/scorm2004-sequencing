require 'spec_helper'
require 'scorm2004/sequencing/attempt_progress_information'

describe Scorm2004::Sequencing::AttemptProgressInformation do
  subject do
    a = double('activity')
    a.extend(Scorm2004::Sequencing::AttemptProgressInformation)
    a.stub(:identifier).and_return('example')
    a
  end

  describe 'defaults' do
    before { subject.stub(:state).and_return({}) }
    its(:attempt_progress_status) { should == false }
    its(:attempt_completion_status) { should == false }
    its(:attempt_completion_amount_status) { should == false }
    its(:attempt_completion_amount) { should == 0.0 }
    its(:attempt_absolute_duration) { should == 0.0 }
    its(:attempt_experienced_duration) { should == 0.0 }
  end

  describe 'example' do
    before do
      state = {
        'activities' => {
          'example' => {
            'attempt_progress_information' => {
              'attempt_progress_status' => true,
              'attempt_completion_status' => true,
              'attempt_completion_amount_status' => true,
              'attempt_completion_amount' => 0.2,
              'attempt_absolute_duration' => 0.4,
              'attempt_experienced_duration' => 0.6
            }
          }
        }
      }
      subject.stub(:state).and_return(state)
    end

    its(:attempt_progress_status) { should == true }
    its(:attempt_completion_status) { should == true }
    its(:attempt_completion_amount_status) { should == true }
    its(:attempt_completion_amount) { should == 0.2 }
    its(:attempt_absolute_duration) { should == 0.4 }
    its(:attempt_experienced_duration) { should == 0.6 }

    describe '#attempt_progress_status=' do
      it 'sets Attempt Progress Status' do
        expect {
          subject.attempt_progress_status = false
        }.to change {
          subject.attempt_progress_status
        }.from(true).to(false)
      end
    end

    describe '#attempt_completion_status' do
      it 'sets Attempt Progress Status' do
        expect {
          subject.attempt_progress_status = false
        }.to change {
          subject.attempt_progress_status
        }.from(true).to(false)
      end
    end

    describe '#attempt_completion_amount_status' do
      it 'sets Attempt Completion Amount Status' do
        expect {
          subject.attempt_completion_amount_status = false
        }.to change {
          subject.attempt_completion_amount_status
        }.from(true).to(false)
      end
    end

    describe '#attempt_completion_amount' do
      it 'sets Attempt Completion Amount' do
        expect {
          subject.attempt_completion_amount = 0.3
        }.to change {
          subject.attempt_completion_amount
        }.from(0.2).to(0.3)
      end
    end

    describe '#attempt_absolute_duration' do
      it 'sets Attempt Absolute Duration' do
        expect {
          subject.attempt_absolute_duration = 0.5
        }.to change {
          subject.attempt_absolute_duration
        }.from(0.4).to(0.5)
      end
    end

    describe '#attempt_experienced_duration' do
      it 'sets Attempt Experienced Duration' do
        expect {
          subject.attempt_experienced_duration = 0.7
        }.to change {
          subject.attempt_experienced_duration
        }.from(0.6).to(0.7)
      end
    end
  end
end
