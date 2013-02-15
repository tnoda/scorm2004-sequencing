require 'scorm2004/sequencing'

module Scorm2004
  module Sequencing
    module NavigationRequestProcess
      # Navigation Request Process [NB.2.1]
      # For a navigation request and possibly a specified activity, returns
      # the validity of the navigation request; may return a termination
      # request, a sequencing request, and/or a target activity; may return an
      # exception code:
      #
      # @param tree [ActivityTree] The activity tree.
      # @param req [Symbol] The navigation request.
      # @param target [String] The target activity's identifier, which can be omitted.
      # @return [Array] An array of [termination_request, sequencing_request].
      def navigation_request_process(tree, req, target = nil)
        case req
        when :start
          start_navigation_request_process(tree, req)
        when :resume_all
          resume_all_navigation_request_process(tree, req)
        when :continue
          continue_navigation_request_process(tree, req)
        when :previous
          previous_navigation_request_process(tree, req)
        when :choice
          choice_navigation_request_process(tree, req, target)
        when :exit
          exit_navigation_request_process(tree, req)
        when :exit_all
          exit_all_navigation_request_process(tree, req)
        when :suspend_all
          suspend_all_navigation_request_process(tree, req)
        when :abandon
          abandon_navigation_request_process(tree, req)
        when :jump
          jump_navigation_request_process(tree, req, target)
        else
          sequencing_exception('NB.2.1-13')
        end
      end

      private

      def start_navigation_request_process(tree, req)
        sequencing_exception('NB.2.1-1') if tree.current_activity
        [nil, :start]
      end

      def resume_all_navigation_request_process(tree, req)
        sequencing_exception('NB.2.1-1') if tree.current_activity
        sequencing_exception('NB.2.1-3') unless tree.suspended_activity
        [nil, :resume_all]
      end

      def continue_navigation_request_process(tree, req)
        c = tree.current_activity or sequencing_exception('NB.2.1-2')
        if c.root? || !c.parent.sequencing_control_flow
          sequencing_exception('NB.2.1-4')
        end
        [c.active? ? :exit : nil, :continue]
      end

      def previous_navigation_request_process(tree, req)
        c = tree.current_activity or sequencing_exception('NB.2.1-2')
        sequencing_exception('NB.2.1-6') if c.root?
        p = c.parent
        if !p.sequencing_control_flow || p.sequencing_control_forward_only
          sequencing_exception('NB.2.1-5')
        end
        [c.active? ? :exit : nil, :previous]
      end

      def choice_navigation_request_process(tree, req, target)
        t = tree.activities[target] or sequencing_exception('NB.2.1-11')
        unless t.root? || t.parent.sequencing_control_choice
          sequencing_exception('NB.2.1-11')
        end
        c = tree.current_activity
        if c && c.active?
          sequencing_exception('NB.2.1-8') unless c.sequencing_control_choice_exit
          [:exit, :choice]
        else
          [nil, :choice]
        end
      end

      def exit_navigation_request_process(tree, req)
        c = tree.current_activity or sequencing_exception('NB.2.1-2')
        sequencing_exception('NB.2.1-12') unless c.active?
        [:exit, :exit]
      end

      def exit_all_navigation_request_process(tree, req)
        sequencing_exception('NB.2.1-2') unless tree.current_activity
        [:exit_all, :exit]
      end

      def suspend_all_navigation_request_process(tree, req)
        sequencing_exception('NB.2.12') unless tree.current_activity
        [:suspend_all, :exit]
      end

      def abandon_navigation_request_process(tree, req)
        c = tree.current_activity or sequencing_exception('NB.2.1-2')
        sequencing_exception('NB.2.1-12') unless c.active?
        [:abandon, :exit]
      end

      def jump_navigation_request_process(tree, req, target)
        t = tree.activities[target]
        unless t && t.parent.available_children.include?(t)
          sequencing_exception('NB.2.1-11')
        end
        [:exit, :jump]
      end
    end
  end
end
