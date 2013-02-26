require 'scorm2004/sequencing'
require 'scorm2004/sequencing/sequencing_rules'

describe Scorm2004::Sequencing::SequencingRules do
  subject do
    a = double('activity')
    a.extend(Scorm2004::Sequencing::SequencingRules)
    a
  end

  context 'default' do
    before { subject.stub(:sequencing => {}) }
    its(:sequencing_rules) { should be_empty }
  end

  context 'with rule actions not specified' do
    context 'having four sequencing rules' do
      before do
        klass = double('SequencingRule')
        klass.stub(:new => :dummy_rule)
        stub_const('Scorm2004::Sequencing::SequencingRule', klass)
        subject.stub(:sequencing => {
            'sequencing_rules' => {
              :dummy_condition => Array.new(4) { :dummy_condition }
            }
          } )
      end
      its(:sequencing_rules) { should have(4).sequencing_rules }
    end
  end

  context 'with rule actions and two matched rules' do
    before do
      def dummy_rule(action)
        d = double('SequencingRule')
        d.stub(:rule_action => action)
        d
      end
      dummy_rules = %w( Exit dummy Exit dummy dummy ).map { |a| dummy_rule(a) }
      klass = double('SequencingRule')
      klass.stub(:new) do
        dummy_rules.shift
      end
      stub_const('Scorm2004::Sequencing::SequencingRule', klass)
      subject.stub(:sequencing => {
          'sequencing_rules' => {
            :dummy_condition => Array.new(dummy_rules.length) { :dummy_condition }
          }
        } )
    end

    it "has two sequencing rules matched with the rule actions" do
      subject.sequencing_rules('Exit', 'Skip').should have(2).sequencing_rules
    end
  end
end
