# frozen_string_literal: true

module Robot
  module Parser
    # Base for parser classes
    class Base < SimpleDelegator
      attr_reader :commands_list

      def self.parse(commands_list, executer = Executer)
        new(commands_list, executer).parse
      end

      def initialize(commands_list, executer = Executer)
        @commands_list = commands_list
        super(executer)
      end

      def default_block
        proc { |line| run(line.to_s.strip) }
      end
    end
  end
end
