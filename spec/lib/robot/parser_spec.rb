# frozen_string_literal: true

# lib/parser_spec.rb

require 'spec_helper'

RSpec.describe Robot::Parser do
  before do
    allow(Robot::Parser::FileParser).to receive(:parse)
    allow(Robot::Parser::CommandsParser).to receive(:parse)
  end

  describe '.parse' do
    context 'when passing files' do
      it 'is parsed by file parser' do
        described_class.parse(file: 'path/to/file')
        expect(Robot::Parser::FileParser).to have_received(:parse)
        expect(Robot::Parser::CommandsParser).not_to have_received(:parse)
      end
    end

    context 'when passing commands' do
      it 'is parsed by commands parser' do
        described_class.parse(commands: "PLACE 0,0,NORTH\n MOVE\nRIGHT\nREPORT")
        expect(Robot::Parser::FileParser).not_to have_received(:parse)
        expect(Robot::Parser::CommandsParser).to have_received(:parse)
      end
    end

    context 'when passing invalid parser' do
      it 'does not parse' do
        described_class.parse(failed: 'path/to/file')
        expect(Robot::Parser::FileParser).not_to have_received(:parse)
        expect(Robot::Parser::CommandsParser).not_to have_received(:parse)
      end
    end
  end
end
