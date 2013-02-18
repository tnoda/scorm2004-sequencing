require 'spec_helper'
require 'scorm2004/sequencing/objective'

describe Scorm2004::Sequencing::Objective do
  before do
    activity = double('activity')
    activity.stub(:identifier).and_return('example')
    subject.instance_variable_set(:@activity, activity)
  end

  describe 'defaults' do
    before do
      subject.instance_eval do
        @state = {}
        @objective = { 'objective_id' => 'default_objective' }
      end
    end

    # Objective description
    its(:satisfied_by_measure) { should be_false }
    its(:minimum_satisfied_normalized_measure) { should == 1.0 }

    # Objective progress information
    its(:progress_status) { should be_false }
    its(:satisfied_status) { should be_false }
    its(:measure_status) { should be_false }
    its(:normalized_measure) { should == 0.0 }
    its(:completion_status) { should be_false }
    its(:completion_amount_status) { should be_false }
    its(:completion_amount) { should == 0.0 }

    # Helper methods
    its(:satisfied?) { should be_false }
  end

  describe 'objective description' do
    before do
      subject.instance_eval do
        @objective = {
          'objective_id' => 'default_objective',
          'satisfied_by_measure' => true,
          'min_normalized_measure' => 0.6
        }
      end
    end

    its(:id) { should == 'default_objective' }
    its(:satisfied_by_measure) { should be_true }
    its(:minimum_satisfied_normalized_measure) { should == 0.6 }
  end

  context 'local objective progress information example' do
    before do
      subject.instance_eval do
        @state = {
          'activities' => {
            'example' => {
              'objectives' => {
                'default_objective' => {
                  'progress_status' => true,
                  'satisfied_status' => true,
                  'measure_status' => true,
                  'normalized_measure' => 0.2,
                  'completion_status' => true,
                  'completion_amount_status' => true,
                  'completion_amount' => 0.4
                }
              }
            }
          }
        }
        @objective = { 'objective_id' => 'default_objective' }
      end
    end

    its(:progress_status) { should be_true }
    its(:satisfied_status) { should be_true }
    its(:measure_status) { should be_true }
    its(:normalized_measure) { should == 0.2 }
    its(:completion_status) { should be_true }
    its(:completion_amount_status) { should be_true }
    its(:completion_amount) { should == 0.4 }
    its(:satisfied?) { should be_true }

    describe '#progress_status=' do
      it 'sets Objective Progress Status locally' do
        expect {
          subject.progress_status = false
        }.to change {
          subject.progress_status
        }.from(true).to(false)
      end
    end

    describe '#satisfied_status=' do
      it 'sets Objective Satisfied Status locally' do
        expect {
          subject.satisfied_status = false
        }.to change {
          subject.satisfied_status
        }.from(true).to(false)
      end
    end

    describe '#measure_status' do
      it 'sets Objective Measure Status locally' do
        expect {
          subject.measure_status = false
        }.to change {
          subject.measure_status
        }.from(true).to(false)
      end
    end

    describe '#normalized_measure=' do
      it 'sets Objective Normalized Measure locally' do
        expect {
          subject.normalized_measure = 0.3
        }.to change {
          subject.normalized_measure
        }.from(0.2).to(0.3)
      end
    end

    describe '#completion_status=' do
      it 'sets Objective Completion Status locally' do
        expect {
          subject.completion_status = false
        }.to change {
          subject.completion_status
        }.from(true).to(false)
      end
    end

    describe '#completion_amount_status=' do
      it 'sets Objective Completion Amount Status locally' do
        expect {
          subject.completion_status = false
        }.to change {
          subject.completion_status
        }.from(true).to(false)
      end
    end

    describe '#completion_amount=' do
      it 'sets Objective Completion Amount locally' do
        expect {
          subject.completion_amount = 0.5
        }.to change {
          subject.completion_amount
        }.from(0.4).to(0.5)
      end
    end
  end

  context 'read/write global shared objective progress information' do
    before do
      state = {
        'objectives' => {
          'sgo' => {
            'progress_status' => true,
            'satisfied_status' => true,
            'measure_status' => true,
            'normalized_measure' => 0.2,
          }
        },
      }
      objective = {
        'objective_id' => 'example',
        'map_infos' => [
          {
            'target_objective_id' => 'sgo',
            'write_satisfied_status' => true,
            'write_normalized_measure' => true,
          }
        ]
      }
      subject.instance_eval do
        @state = state
        @objective = objective
      end
    end

    its(:progress_status) { should be_true }
    its(:satisfied_status) { should be_true }
    its(:measure_status) { should be_true }
    its(:normalized_measure) { should == 0.2 }

    describe '#progress_status=' do
      it 'sets Objective Progress Status locally' do
        expect {
          subject.progress_status = false
        }.to change {
          subject.progress_status
        }.from(true).to(false)
      end

      it 'sets Objective Progress Status globally' do
        expect {
          subject.progress_status = false
        }.to change {
          subject.global_progress_status
        }.from(true).to(false)
      end
    end

    describe '#satisfied_status=' do
      it 'sets Objective Progress Status locally' do
        expect {
          subject.satisfied_status = false
        }.to change {
          subject.satisfied_status
        }.from(true).to(false)
      end

      it 'sets Objective Satisfied Status globally' do
        expect {
          subject.satisfied_status = false
        }.to change {
          subject.global_satisfied_status
        }.from(true).to(false)
      end
    end

    describe '#measure_status=' do
      it 'sets Objective Measure Status locally' do
        expect {
          subject.measure_status = false
        }.to change {
          subject.measure_status
        }.from(true).to(false)
      end

      it 'sets Objective Measure Status globally' do
        expect {
          subject.measure_status = false
        }.to change {
          subject.global_measure_status
        }.from(true).to(false)
      end
    end

    describe '#normalized_measure=' do
      it 'sets Objective Normalized Measure locally' do
        expect {
          subject.normalized_measure = 0.6
        }.to change {
          subject.normalized_measure
        }.from(0.2).to(0.6)
      end

      it 'sets Objective Normalized Measure globally' do
        expect {
          subject.normalized_measure = 0.6
        }.to change {
          subject.global_normalized_measure
        }.from(0.2).to(0.6)
      end
    end
  end

  pending '<adlseq:objectives> support'
end
