require 'scorm2004/sequencing'
require 'forwardable'

module Scorm2004
  module Sequencing
    # Termination Request Process [TB.2.3]
    #
    # @example
    #   TerminationRequestProcess.new(tree).call(termination_request)
    #
    class TerminationRequestProcess < AbstractProcess
      class Exit < self
        POST_CONDITION_ACTIONS = [
          'Retry', 'Continue', 'Previous',
          'Exit Parent', 'Exit All', 'Retry All'
        ]

        def initialize(tree)
          super
        end

        def call
          end_attempt
          sequencing_exit_action_rules_subprocess.call
          main_loop
        end

        private

        # Sequencing Post Condition Rules Subprocess [TB.2.2] is substituted
        # with this +main_loop+ method.
        def main_loop
          return if suspended?

          # Apply the Sequencing Exit Action Rules Subprocess to the Current Activity.
          action = check_sequencing_rules(*POST_CONDITION_ACTIONS)

          case action
          when 'Exit All', 'Retry All'
            return ExitAll.new(@tree).call
          when 'Exit Parent'
            sequencing_exception('TB.2.3-4') if root?
            set_current_activity(parent)
            end_attempt
            return main_loop
          when 'Continue', 'Previous'
            return :exit if root?
          end
          action && action.gsub(/ /, '_').downcase.intern
        end
      end

      class ExitAll < self
        def initialize(tree)
          super
        end

        def call
          end_attempt if active?
          terminate_descendent_attempts_process.call(root_activity)
          root_activity.end_attempt
          set_current_activity(root_activity)

          :exit
        end
      end

      class SuspendAll < self
        def initialize(tree)
          super
        end

        def call
          if active? && suspended?
            rollup
            tree.suspended_activity = current_activity
          else
            sequencing_exception('TB.2.3-3') if root?
            tree.current_activity = parent
          end

          # Form the activity path as the ordered series of all activities from
          # the Suspended Activity to the root of the activity tree, inclusive
          activity_path = suspended_activity.ancestors(true)
          sequencing_exception('TB.2.3-5') if activity_path.empty?
          activity_path.each do |a|
            a.activity_is_active = false
            a.activity_is_suspended = true
          end
          set_current_activity(root_activity)

          :exit
        end
      end

      class Abandon < self
        def initialize(tree)
          super
        end

        def call
          current_activity.activity_is_active = false

          nil
        end
      end

      class AbandonAll < self
        def initialize(tree)
          super
        end

        def call
          # Form the activity path as the ordered series of all activities from
          # the Current Activity to the root of the activity tree, inclusive
          activity_path = current_activity.ancestors(true)
          sequencing_exception('TB.2.3-6') if activity_path.empty?
          activity_path.each do |a|
            a.activity_is_active = false
          end
          set_current_activity(root_activity)

          nil
        end
      end


      def initialize(tree)
        super
      end

      # @param req [Symbol] the termination request
      # @return [Symbol] the sequencing request
      def call(req)
        sequencing_exception('TB.2.3-1') unless current_activity
        if %i( exit abandon ).include?(req) && !active?
          sequencing_exception('TB.2.3-2')
        end

        case req
        when :exit
          Exit
        when :exit_all
          ExitAll
        when :suspend_all
          SuspendAll
        when :abandon
          Abandon
        when :abandon_all
          AbandonAll
        else
          sequencing_exception('TB.2.3-7')
        end.new(@tree).call
      end
    end
  end
end
