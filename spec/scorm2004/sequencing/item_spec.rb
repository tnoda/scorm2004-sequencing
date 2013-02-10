require 'spec_helper'
require 'scorm2004/sequencing/item'

describe Scorm2004::Sequencing::Item do
  let(:mock_item) { Object.new.extend(Scorm2004::Sequencing::Item) }

  describe 'an empty item' do
    subject do
      mock_item.instance_eval do
        @item = {}
      end
      mock_item
    end

    its(:identifier) { should be_nil }
    its(:title) { should be_nil }
  end

  describe 'a sample item' do
    subject do
      mock_item.instance_eval do
        @item = {
          'title' => 'a sample item',
          'identifier' => 'smpl0'
        }
      end
      mock_item
    end

    its(:identifier) { should == 'smpl0' }
    its(:title) { should == 'a sample item' }
  end
end
