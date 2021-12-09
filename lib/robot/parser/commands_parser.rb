# frozen_string_literal: true

module Robot
  module Parser
    # CommandParser process the commands
    class CommandsParser < Base
      def parse(&block)
        runner = block_given? ? block : default_block
        commands_list.split("\n").each(&runner)
      end
    end
  end
end
