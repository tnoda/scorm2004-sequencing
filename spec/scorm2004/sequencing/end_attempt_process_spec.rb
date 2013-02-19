require 'spec_helper'
require 'scorm2004/sequencing/end_attempt_process'

describe Scorm2004::Sequencing::EndAttemptProcess do
  subject do
    obj = double('activity')
    obj.stub(:item).and_return({})
    obj.extend(Scorm2004::Sequencing::EndAttemptProcess)
    obj.should_receive(:activity_is_active=).with(false)
    obj.should_receive(:rollup)
    obj.stub(:identifier).and_return('example')
    obj
  end

  shared_examples 'only ending the current attempt' do
    it 'ends the current attempt' do
      subject.end_attempt
    end
  end

  context 'cluster' do
    before do
      subject.stub(:leaf?).and_return(false)
    end

    context 'has a suspended child' do
      before do
        sc = double('suspended child')
        sc.stub(:suspended?).and_return(true)
        c0 = double('child')
        c0.stub(:suspended?).and_return(false)
        subject.stub(:children).and_return([c0, sc])
      end

      it 'suspends itself and ends the current attempt' do
        subject.should_receive(:activity_is_suspended=).with(true)
        subject.end_attempt
      end
    end

    context 'has not any suspended children' do
      before do
        children = %w( c0 c1 c2 ).map do |identifier|
          c = double(identifier)
          c.stub(:suspended?).and_return(false)
          c
        end
        subject.stub(:children).and_return(children)
      end

      it_behaves_like 'only ending the current attempt'
    end
  end

  shared_context 'tracked' do |flag|
    before { subject.stub(:tracked?).and_return(flag) }
  end

  shared_context 'suspended' do |flag|
    before { subject.stub(:suspended?).and_return(flag) }
  end

  shared_context 'tracked and not suspended' do |completion, objective|
    include_context 'tracked', true
    include_context 'suspended', false
    before do
      subject.stub(:completion_set_by_content).and_return(completion)
      subject.stub(:objective_set_by_content).and_return(objective)
    end
  end

  shared_context 'Attempt Progress Status' do |flag|
    before { subject.stub(:attempt_progress_status).and_return(flag) }
  end

  shared_context 'rolled-up objective' do |existence, flag|
    before do
      if existence
        ro = double('rolled-up objective')
        ro.stub(:progress_status).and_return(flag)
        subject.stub(:rolled_up_objective).and_return(ro)
      else
        subject.stub(:rolled_up_objective).and_return(nil)
      end
    end
  end

  shared_examples 'leaf end attempt process' do |completion, objective|
    it "ends the current attempt; completion: #{completion}, objective: #{objective}" do
      if completion
        subject.should_receive(:attempt_progress_status=).with(true)
        subject.should_receive(:attempt_completion_status=).with(true)
      end

      if objective
        ro = subject.rolled_up_objective
        ro.should_receive(:progress_status=).with(true)
        ro.should_receive(:satisfied_status=).with(true)
      end

      subject.end_attempt
    end
  end

  context 'leaf' do
    before { subject.stub(:leaf?).and_return(true) }

    context 'not tracked' do
      include_context 'tracked', false
      it_behaves_like 'only ending the current attempt'
    end

    context 'tracked but suspended' do
      include_context 'tracked', true
      include_context 'suspended', true
      it_behaves_like 'only ending the current attempt'
    end

    context 'both completion and objective are set by content' do
      include_context 'tracked and not suspended', true, true
      it_behaves_like 'only ending the current attempt'
    end

    context 'only objective is set by content' do
      include_context 'tracked and not suspended', false, true

      context 'with Attempt Progress Status true' do
        include_context 'Attempt Progress Status', true
        it_behaves_like 'only ending the current attempt'
      end

      context 'with Attempt Progress Status false' do
        include_context 'Attempt Progress Status', false
        it_behaves_like 'leaf end attempt process', true, false
      end
    end

    context 'only completion is set by content' do
      include_context 'tracked and not suspended', true, false

      context 'has no rolled-up objective' do
        include_context 'rolled-up objective', nil
        it_behaves_like 'only ending the current attempt'
      end

      context 'has a rolled-up objective with progress status true' do
        include_context 'rolled-up objective', true, true
        it_behaves_like 'only ending the current attempt'
      end

      context 'has a rolled-up objective with progress status false' do
        include_context 'rolled-up objective', true, false
        it_behaves_like 'leaf end attempt process', false, true
      end
    end

    context 'neither completion nor objective status is set by content' do
      include_context 'tracked and not suspended', false, false

      context 'with Attempt Progress Status true' do
        include_context 'Attempt Progress Status', true

        context 'has no rolled-up objective' do
          include_context 'rolled-up objective', nil
          it_behaves_like 'only ending the current attempt'
        end

        context 'has a rolled-up objective with progress status true' do
          include_context 'rolled-up objective', true, true
          it_behaves_like 'only ending the current attempt'
        end

        context 'has a rolled-up objective with progress status false' do
          include_context 'rolled-up objective', true, false
          it_behaves_like 'leaf end attempt process', false, true
        end
      end

      context 'with Attempt Progress Status false' do
        include_context 'Attempt Progress Status', false

        context 'has no rolled-up objective' do
          include_context 'rolled-up objective', nil
          it_behaves_like 'leaf end attempt process', true, false
        end

        context 'has a rolled-up objective with progress status true' do
          include_context 'rolled-up objective', true, true
          it_behaves_like 'leaf end attempt process', true, false
        end

        context 'has a rolled-up objective with progress status false' do
          include_context 'rolled-up objective', true, false
          it_behaves_like 'leaf end attempt process', true, true
        end
      end
    end
  end
end
