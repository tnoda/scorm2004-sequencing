require 'spec_helper'
require 'scorm2004/sequencing/terminate_descendent_attempts_process'

describe Scorm2004::Sequencing::TerminateDescendentAttemptsProcess do
  it 'invoke end attempt process against descendent activities' do
    def terminated_activity
      a = double('terminated activity')
      a.should_receive(:end_attempt)
      a
    end
    def dummy_activity
      double('dummy activity')
    end
    t0, t1, t2 = Array.new(3) { terminated_activity }
    d0, d1, d2, d3 = Array.new(3) { dummy_activity }
    tree = double('activity tree')
    current_activity = double('current activity')
    current_activity.stub(:ancestors => [d0, d1, d2, t0, t1, t2])
    common_ancestor = double('common ancestor')
    common_ancestor.stub(:ancestors => [d0, d1, d2])
    tree.should_receive(:current_activity).twice.and_return(current_activity)
    tree.should_receive(:common_ancestor).and_return(common_ancestor)
    described_class.new(tree).call(:dummy)
  end
end
