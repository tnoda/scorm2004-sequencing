require 'spec_helper'
require 'scorm2004/sequencing/cam/objective'

describe Scorm2004::Sequencing::Cam::Objective do
  subject { Object.new.extend(Scorm2004::Sequencing::Cam::Objective) }

  describe 'defaults' do
    before { subject.instance_variable_set(:@objective, {})}
    its(:satisfied_by_measure) { should be_false }
    its(:minimum_satisfied_normalized_measure) { should == 1.0 }
    its(:map_infos) { should be_empty }
  end

  describe 'example' do
    before do
      objective = {
        'objective_id' => 'primary_objective',
        'satisfied_by_measure' => true,
        'min_normalized_measure' => 0.5
      }
      subject.instance_variable_set(:@objective, objective)
    end

    its(:id) { should == 'primary_objective' }
    its(:satisfied_by_measure) { should be_true }
    its(:minimum_satisfied_normalized_measure) { should == 0.5 }
  end

  describe 'example with two map_infos' do
    before do
      objective = {
        'objective_id' => 'with_map_infos',
        'map_infos' => [
          { 'target_objective_id' => 'the_target'
          },
          { 'target_objective_id' => 'another_target',
            'read_satisfied_status' => false,
            'read_normalized_measure' => false,
            'write_satisfied_status' => true,
            'write_normalized_measure' => true,
            'read_min_score' => false,
            'read_max_score' => false,
            'read_completion_status' => false,
            'read_progress_measure' => false,
            'write_min_score' => true,
            'write_max_score' => true,
            'write_completion_status' => true,
            'write_progress_measure' => true
          } ]
        }
        subject.instance_variable_set(:@objective, objective)
      end

    its(:map_infos) { should have(2).map_info }

    describe 'map_info default' do
      its('map_infos.first.read_satisfied_status') { should be_true }
      its('map_infos.first.read_normalized_measure') { should be_true }
      its('map_infos.first.write_satisfied_status') { should be_false }
      its('map_infos.first.write_normalized_measure') { should be_false }
      its('map_infos.first.read_min_score') { should be_true }
      its('map_infos.first.read_max_score') { should be_true }
      its('map_infos.first.read_completion_status') { should be_true }
      its('map_infos.first.read_progress_measure') { should be_true }
      its('map_infos.first.write_min_score') { should be_false }
      its('map_infos.first.write_max_score') { should be_false }
      its('map_infos.first.write_completion_status') { should be_false }
      its('map_infos.first.write_progress_measure') { should be_false }
    end

    describe 'map_info example' do
      its('map_infos.last.target_objective_id') { should == 'another_target' }
      its('map_infos.last.read_satisfied_status') { should be_false }
      its('map_infos.last.read_normalized_measure') { should be_false }
      its('map_infos.last.write_satisfied_status') { should be_true }
      its('map_infos.last.write_normalized_measure') { should be_true }
      its('map_infos.last.read_min_score') { should be_false }
      its('map_infos.last.read_max_score') { should be_false }
      its('map_infos.last.read_completion_status') { should be_false }
      its('map_infos.last.read_progress_measure') { should be_false }
      its('map_infos.last.write_min_score') { should be_true }
      its('map_infos.last.write_max_score') { should be_true }
      its('map_infos.last.write_completion_status') { should be_true }
      its('map_infos.last.write_progress_measure') { should be_true }
    end
  end
end
