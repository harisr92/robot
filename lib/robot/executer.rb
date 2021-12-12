# frozen_string_literal: true

module Robot
  # Executer to perform commands on robot toy
  class Executer
    attr_accessor :stdout

    def self.run(*args)
      new(*args).run
    end

    def initialize(cmd, game = Game.init, toy = Toy, stdout = nil)
      @cmd = cmd
      @game = game
      @toy = toy
      @stdout = Output.find(stdout.to_s)
      @game.printer = @stdout
    end

    def run
      parse
      return if @cmd.to_s.strip == ''

      execute_on_toy
      @game.validate!
      @game.save
    rescue Toy::Invalid => e
      stdout.out e, formats: :red
    end

    private

    def parse
      cmd, args = @cmd.to_s.split
      @cmd = cmd.to_s.strip.downcase
      @args = sanitize_positions(args)
    end

    def sanitize_positions(args)
      x_axis, y_axis, direction = args.to_s.split(',')
      return [] if x_axis.nil?

      { x_axis: x_axis, y_axis: y_axis, direction: direction.to_s.downcase }
    end

    def execute_on_toy
      @args = @args.to_h
      @game.method(@cmd).call(**@args)
    rescue NameError
      stdout.out "Game does not know how to do #{@cmd}"
    end
  end
end
