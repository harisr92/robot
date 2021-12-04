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

    desc 'execute file, -', 'Robot can execute a series of commands. Single command per line'
    method_option :file, aliases: '-f',
                         desc: 'Robot commands are fetched from the supplied file, each command in each line'
    method_option :conf, aliases: '-c', desc: 'Robot commands from command line per line'
    def execute
      robo_commands.each do |command|
        cmd, args = sanitize_command(command)
        next unless cmd && valid_cmd?(cmd)

        exec_cmd(cmd, args)
      end
    end

    desc 'Place the robot at X,Y and direction', 'Place the robot on table at position X, Y and direction'
    def place(args)
      x_axis, y_axis, direction = sanitize_positions(args)
      table.place_robot(x_axis: x_axis, y_axis: y_axis, direction: direction)
      table.update
    rescue Toy::Invalid
      nil
    end

    desc 'Turn robot to left', 'Turn robot 90 degrees to the left'
    def left
      return unless table.toy

      table.toy.left
      table.update
    end

    desc 'Turn robot to right', 'Turn robot 90 degrees to the right'
    def right
      return unless table.toy

      table.toy.right
      table.update
    end

    desc 'Move robot', 'Move robot one unit to the direction'
    def move
      return unless table.toy

      table.toy.move
      table.update
    rescue Toy::Invalid
      nil
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

    def sanitize_command(command)
      cmd, args = command.to_s.split.map { |element| element.strip.downcase }.reject(&:empty?)
      return ['', nil] unless cmd

      [cmd.downcase, args]
    end

    def exec_cmd(cmd, args)
      if method(cmd).arity.zero?
        send(cmd)
      else
        send(cmd, *[args].flatten.compact)
      end
    end

    def robo_commands
      @robo_commands ||=
        if options[:conf]
          options[:conf].split("\n")
        elsif options[:file] && File.exist?(file = file_path)
          File.read(file).split("\n")
        else
          []
        end
    end

    def file_path
      return '' unless options[:file]

      path = Pathname.new(options[:file])
      if path.absolute?
        path.join(Dir.pwd, path)
      else
        path
      end
    end

    def valid_cmd?(cmd)
      self.class.all_commands.include?(cmd)
    end
  end
end
