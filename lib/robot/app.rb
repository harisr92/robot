# frozen_string_literal: true

module Robot
  # Starting point for robot app
  class App < Thor
    namespace :robot

    def self.exit_on_failure?
      true
    end

    desc 'Start console', 'start robot console'
    def console
      Pry.start
    end

    desc 'Place the robot at X,Y and direction', 'Place the robot on table at position X, Y and direction'
    def place(args)
      x_axis, y_axis, direction = sanitize_positions(args)
      table.place_robot(x_axis: x_axis, y_axis: y_axis, direction: direction)
      table.update
    rescue Toy::Invalid => e
      unless ENV['APP_ENV'] == 'test'
        shell.say e.message
        exit(1)
      end
    end

    desc 'Turn robot to left', 'Turn robot 90 degrees to the left'
    def left
      return unless table.toy

      table.toy.left
      table.update
    end

    desc 'Get position of robot', 'Get position of the robot on the table'
    def report
      shell.say Table.report
    end

    desc 'Reset table and remove robot', 'Removes robot from the table and gives a clean table'
    def reset
      Storage.reset
    end

    private

    def table
      @table ||= Table.init
    end

    def sanitize_positions(args)
      x_axis, y_axis, direction = args.split(',')
      [x_axis.to_i, y_axis.to_i, direction.to_s.downcase]
    end
  end
end
