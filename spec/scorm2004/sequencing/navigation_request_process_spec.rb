require 'spec_helper'
require 'scorm2004/sequencing/navigation_request_process'
require 'scorm2004/sequencing/sequencing_exception'
require 'ostruct'

describe Scorm2004::Sequencing::NavigationRequestProcess do
  subject do
    Object.new
      .extend(Scorm2004::Sequencing::SequencingException)
      .extend(Scorm2004::Sequencing::NavigationRequestProcess)
  end
  let(:tree) { OpenStruct.new }
  let(:target) { nil }
  let(:process) { subject.navigation_request_process(tree, req, target) }

  shared_examples_for 'sequencing exception' do
    it 'throws a sequencing exception' do
      expect { process }.to throw_symbol(:sequencing_exception)
      subject.exception.should be
    end
  end

  describe 'Start navigation request' do
    let(:req) { :start }

    context 'when the current activity is defined' do
      before { tree.current_activity = :dummy }
      it_behaves_like 'sequencing exception'
    end

    context 'when the current activity is not defined' do
      it 'issues a Start sequencing request' do
        process.should == [nil, :start]
      end
    end
  end

  describe 'Resume All navigation request' do
    let(:req) { :resume_all }

    context 'when the current activity is defined' do
      before { tree.current_activity = :dummy }
      it_behaves_like 'sequencing exception'
    end

    context 'when the suspended activity is defined' do
      before { tree.suspended_activity = :dummy }
      it 'issues a Resume All sequencing request' do
        process.should == [nil, :resume_all]
      end
    end

    context 'when the suspended activity is not defined' do
      it_behaves_like 'sequencing exception'
    end
  end

  describe 'Continue navigation request' do
    let(:req) { :continue }

    context 'when the current activity is not defined' do
      it_behaves_like 'sequencing exception'
    end

    context 'when the current activity is defined' do
      context 'and is the root activity' do
        before do
          tree.current_activity = double('current activity')
          tree.current_activity.stub(:root?).and_return(true)
        end
        it_behaves_like 'sequencing exception'
      end

      context 'and has a parent' do
        before do
          tree.current_activity = OpenStruct.new(:root? => false)
          tree.current_activity.parent = double('parent activity')
        end

        context 'whose Sequencing Control Flow is False' do
          before { tree.current_activity.parent.stub(:sequencing_control_flow).and_return(false) }
          it_behaves_like 'sequencing exception'
        end

        context 'whose Sequencing Control Flow is True' do
          before { tree.current_activity.parent.stub(:sequencing_control_flow).and_return(true) }

          context 'when the current activity is active' do
            before { tree.current_activity.stub(:active?).and_return(true) }
            it 'terminates the current activity first' do
              process.should == [:exit, :continue]
            end
          end

          context 'when the current activity is not active' do
            before { tree.current_activity.stub(:active?).and_return(false) }
            it 'issues the Continue sequencing request' do
              process.should == [nil, :continue]
            end
          end
        end
      end
    end
  end

  describe 'Previous navigation request' do
    let(:req) { :previous }

    context 'when the current activity is not defined' do
      it_behaves_like 'sequencing exception'
    end

    context 'when the current activity is defined' do
      context 'and is the root activity' do
        before do
          tree.current_activity = double('current activity')
          tree.current_activity.stub(:root?).and_return(true)
        end
        it_behaves_like 'sequencing exception'
      end

      context 'and has a parent' do
        before do
          tree.current_activity = OpenStruct.new(:root => false)
          tree.current_activity.parent = double('parent activity')
        end

        context 'whose Sequencing Control Flow is false' do
          before do
            p = tree.current_activity.parent
            p.stub(:sequencing_control_flow).and_return(false)
            p.stub(:sequencing_control_forward_only).and_return(false)
          end
          it_behaves_like 'sequencing exception'
        end

        context 'whose Sequencing Control Forward Only is true' do
          before do
            p = tree.current_activity.parent
            p.stub(:sequencing_control_flow).and_return(true)
            p.stub(:sequencing_control_forward_only).and_return(true)
          end
          it_behaves_like 'sequencing exception'
        end

        context 'which allows the flow sequencing request from the current activity' do
          before do
            p = tree.current_activity.parent
            p.stub(:sequencing_control_flow).and_return(true)
            p.stub(:sequencing_control_forward_only).and_return(false)
          end

          context 'when the current activity is active' do
            before { tree.current_activity.stub(:active?).and_return(true) }
            it 'terminates the current activity' do
              process.should == [:exit, :previous]
            end
          end
          
          context 'when the current activity is not active' do
            before { tree.current_activity.stub(:active?).and_return(false) }
            it 'issues the previous sequencing request' do
              process.should == [nil, :previous]
            end
          end
        end
      end
    end
  end
  
  describe 'Choice navigation request' do
    let(:req) { :choice }
    let(:target) { 'target' }

    context 'when the target activity does not exist' do
      before { tree.activities = OpenStruct.new }
      it_behaves_like 'sequencing exception'
    end

    context 'when the target activity is the root activity' do
      before do
        r = double('root activity')
        tree.activities = {target => r}
        r.stub(:root?).and_return(true)
      end

      context 'and the current activity is not defined' do
        it 'issues the choice sequencing request' do
          process.should == [nil, :choice]
        end
      end

      context 'there is a current activity defined' do
        context 'whose Sequencing Control Choice Exit is true' do
          before do
            c = double('current activity')
            c.stub(:sequencing_control_choice_exit).and_return(true)
            tree.current_activity = c
          end

          context 'when the current activity is active' do
            before { tree.current_activity.stub(:active?).and_return(true) }
            it 'terminates the current activity' do
              process.should == [:exit, :choice]
            end
          end

          context 'when the current activity is not active' do
            before { tree.current_activity.stub(:active?).and_return(false) }
            it 'issues the choice sequencing request' do
              process.should == [nil, :choice]
            end
          end
        end
        
        context 'whose Sequencing Control Choice Exit is false' do
          before do
            c = double('current activity')
            c.stub(:sequencing_control_choice_exit).and_return(false)
            tree.current_activity = c
          end

          context 'when the current activity is active' do
            before { tree.current_activity.stub(:active?).and_return(true) }
            it_behaves_like 'sequencing exception'
          end

          context 'when the current activity is not active' do
            before { tree.current_activity.stub(:active?).and_return(false) }
            it 'issues the choice sequencing request' do
              process.should == [nil, :choice]
            end
          end
        end
      end
    end

    context 'when the target activity is not the root activity' do
      context "whose parent's Sequencing Control Choice is false" do
        before do
          t = double('target activity')
          t.stub(:root?).and_return(false)
          t.stub(:parent).and_return(double('parent activity'))
          tree.activities = {target => t}
        end

        context 'and Sequencing Control Choice for the parent activity is false' do
          before { tree.activities[target].parent.stub(:sequencing_control_choice).and_return(false) }
          it_behaves_like 'sequencing exception'
        end

        context 'and Sequencing Control Choice for the parent activity is true' do
          before { tree.activities[target].parent.stub(:sequencing_control_choice).and_return(true) }

          context "the current activity is defined" do
            before { tree.current_activity = double('current activity') }

            context 'whose Sequencing Control Choice Exit is false' do
              before { tree.current_activity.stub(:sequencing_control_choice_exit).and_return(false) }

              context 'when the current activity is active' do
                before { tree.current_activity.stub(:active?).and_return(true) }
                it_behaves_like 'sequencing exception'
              end

              context 'when the current activity is not active' do
                before { tree.current_activity.stub(:active?).and_return(false) }
                it 'issues the choice sequencing request' do
                  process.should == [nil, :choice]
                end
              end
            end

            context 'whose Sequencing Control Choice Exit is true' do
              before { tree.current_activity.stub(:sequencing_control_choice_exit).and_return(true) }

              context 'when the current activity is active' do
                before { tree.current_activity.stub(:active?).and_return(true) }
                it 'terminates the current activity' do
                  process.should == [:exit, :choice]
                end
              end

              context 'when the current activity is not active' do
                before { tree.current_activity.stub(:active?).and_return(false) }
                it 'issues the choice sequencing request' do
                  process.should == [nil, :choice]
                end
              end
            end
          end

          context "the current activity is not defined" do
            it 'issues the choice sequencing request' do
              process.should == [nil, :choice]
            end
          end
        end
      end
    end
  end

  describe 'Jump navigation request'

  describe 'Exit navigation request' do
    let(:req) { :exit }

    context 'when the current activity is not defined' do
      it_behaves_like 'sequencing exception'
    end

    context 'when the current activity is defined' do
      before do
        tree.current_activity = double('current activity')
      end

      context 'when the current activity is not active' do
        before { tree.current_activity.stub(:active?).and_return(false) }
        it_behaves_like 'sequencing exception'
      end

      context 'when the current activity is active' do
        before { tree.current_activity.stub(:active?).and_return(true) }
        it 'terminates the current activity' do
          process.should == [:exit, :exit]
        end
      end
    end
  end

  describe 'Exit All navigation request'
  describe 'Suspend All navigation request'
end
