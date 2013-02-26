require 'spec_helper'
require 'scorm2004/sequencing/sequencing_rules_check_process'

describe Scorm2004::Sequencing::SequencingRulesCheckProcess do
  describe '#call' do
    it 'finds appropriate sequencing rules and sends #check to these rules' do
      a = double('activity')
      def dummy_rule(a)
        r = double('sequencing rule')
        r.should_receive(:check).with(a)
        r
      end
      a.should_receive(:sequencing_rules) do
        Array.new(5) { dummy_rule(a) }
      end
      described_class.new(a).call(:dummy, :dummy, :dummy)
    end
  end
end
