require 'spec_helper'
require 'scorm2004/sequencing/cam/sequencing'

describe Scorm2004::Sequencing::Cam::Sequencing do
  subject do
    a = double('activity')
    a.extend(Scorm2004::Sequencing::Cam::Sequencing)
    a
  end

  describe 'defaults' do
    before do
      subject.stub(:manifest).and_return({})
      subject.stub(:item).and_return({})
    end

    its(:sequencing) { should == {} }
  end

  context 'does not refer the sequencing collection' do
    before do
      item = {
        'sequencing' => {
          :dummy => true
        }
      }
      subject.stub(:item).and_return(item)
    end

    its(:sequencing) { should == { :dummy => true } }
  end

  context 'refers the sequencing collection' do
    before do
      item = {
        'sequencing' => {
          'id_ref' => 'rs'
        }
      }
      subject.stub(:item).and_return(item)
      manifest = {
        'sequencing_collection' => {
          'sequencings' => [
            {
              'id' => 'rs',
              :dummy => 'foo'
            } 
          ]
        }
      }
      subject.stub(:manifest).and_return(manifest)
    end

    it 'refers the sequencing in the sequencing collection' do
      subject.sequencing[:dummy].should == 'foo'
    end
  end

  context 'has a local sequencing that refers the sequencing collection' do
    before do
      item = {
        'sequencing' => {
          'id_ref' => 'rs',
          :foo => 'foo'
        }
      }
      subject.stub(:item).and_return(item)
      manifest = {
        'sequencing_collection' => {
          'sequencings' => [
            {
              'id' => 'rs',
              :foo => '_foo',
              :bar => '_bar'
            }
          ]
        }
      }
      subject.stub(:manifest).and_return(manifest)
    end

    it 'does not overwrite a local sequencing element' do
      subject.sequencing[:foo].should == 'foo'
    end

    it 'merges the referenced sequencing with the local sequencing' do
      subject.sequencing[:bar].should == '_bar'
    end
  end
end
