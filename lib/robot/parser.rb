# frozen_string_literal: true

module Robot
  # Parser decides which parser to use
  module Parser
    PARSERS = {
      file: Parser::FileParser,
      commands: Parser::CommandsParser
    }.freeze

    def self.parse(options = {})
      key = options.keys.first
      return unless PARSERS.keys.include?(key.to_s.to_sym)

      PARSERS[key.to_sym].parse(options[key])
    end
  end
end
