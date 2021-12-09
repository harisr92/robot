# frozen_string_literal: true

module Robot
  # Executer to perform commands on robot toy
  class Executer
    attr_accessor :stdout

    def self.run(cmd)
      new(cmd).run
    end

    def initialize(cmd, table = Table.init, toy = Toy, stdout = Shell.new)
      @cmd = cmd
      @table = table
      @toy = toy
      @stdout = stdout
    end

    def run
      parse
      return if @cmd.to_s.strip == ''

      @table.toy = execute_on_toy
      @table.update
    rescue Toy::Invalid => e
      stdout.puts e, :red
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

      { x_axis: x_axis, y_axis: y_axis, direction: direction.to_s.downcase, table: @table }
    end

    def execute_on_toy
      toy = @table.toy
      return place_toy unless toy.respond_to?(@cmd)

      resp = toy.method(@cmd).call(@args)
      stdout.puts(resp) if resp
      toy
    end

    def place_toy
      return @table.toy unless @cmd == 'place'

      @toy.place(**@args)
    end
  end
end
