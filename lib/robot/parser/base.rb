# frozen_string_literal: true

module Robot
  module Parser
    # Base for parser classes
    class Base < SimpleDelegator
      attr_reader :commands_list

      def self.parse(cmd, executer = Executer, output = nil)
        new(cmd, executer, output).parse
      end

      def initialize(cmd, executer = Executer, output = nil)
        @commands_list = cmd
        @output = output || 'shell'
        super(executer)
      end

      def default_block
        proc { |line| run(line.to_s.strip, Game.init, Toy, @output) }
      end
    end
  end
end
