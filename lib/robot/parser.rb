# frozen_string_literal: true

module Robot
  # Parser decides which parser to use
  module Parser
    PARSERS = {
      file: Parser::FileParser,
      commands: Parser::CommandsParser
    }.freeze

    class << self
      def parse(options = {})
        parser = nil
        cmd_list = nil
        options.each do |key, val|
          parser = PARSERS[key.to_sym]
          cmd_list = val
          break if parser
        end
        return unless parser

        parser.parse(cmd_list, Executer, options[:output])
      end
    end
  end
end
