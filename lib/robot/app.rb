# frozen_string_literal: true

module Robot
  # Starting point for robot app
  class App < Thor
    namespace :robot
    map '-R' => :report

    def self.exit_on_failure?
      true
    end

    desc 'console', 'start robot console'
    def console
      Pry.start
    end

    desc 'execute | EXECUTE', 'Robot can execute a series of commands. Single command per line'
    method_option :file, aliases: '-f',
                         desc: 'Robot commands are fetched from the supplied file, each command in each line'
    method_option :commands, aliases: '-c', desc: 'Robot commands from command line per line'
    def execute
      Parser.parse(options)
    end

    desc 'reset', 'remove robot from the table'
    def reset
      Storage.reset
    end
  end
end
