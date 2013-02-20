require 'spec_helper'
require 'scorm2004/sequencing/completion_threshold'

describe Scorm2004::Sequencing::CompletionThreshold do
  subject do
    a = double('activity')
    a.extend(Scorm2004::Sequencing::CompletionThreshold)
    a
  end

  describe 'defaults' do
    before { subject.stub(:item).and_return({}) }
    its(:completed_by_measure) { should be_false }
    its(:minimum_progress_measure) { should == 1.0 }
    its(:progress_weight) { should == 1.0 }
  end

  describe 'example' do
    before do
      completion_threshold = {
        'completed_by_measure' => true,
        'min_progress_measure' => 0.2,
        'progress_weight' => 0.4
      }
      subject.stub(:item).and_return('completion_threshold' => completion_threshold)
    end

    its(:completed_by_measure) { should be_true }
    its(:minimum_progress_measure) { should == 0.2 }
    its(:progress_weight) { should == 0.4 }
  end
end
