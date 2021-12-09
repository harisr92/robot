# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Robot::Parser::FileParser do
  let(:executer) { class_double(Robot::Executer, run: true) }

  describe '.parse' do
    context 'when file exist' do
      it 'execute the commands in file' do
        described_class.parse('./spec/templates/commands.txt', executer)
        expect(executer).to have_received(:run).at_least(:once)
      end
    end

    context 'when file does not exist' do
      before do
        allow(File).to receive(:open)
      end

      it 'does not open the file' do
        described_class.parse('./non/existing/file', executer)
        expect(File).not_to have_received(:open)
        expect(executer).not_to have_received(:run)
      end
    end

    context 'when file is in real path' do
      before do
        allow(File).to receive(:open)
      end

      it 'opens real path' do
        path = "#{Dir.pwd}/spec/templates/commands.txt"
        described_class.parse(path, executer)
        expect(File).to have_received(:open).with(Pathname.new(path), 'r')
      end
    end
  end

  describe '#parse' do
    context 'when block is given' do
      it 'executes command in block' do
        parser = described_class.new('./spec/templates/commands.txt')
        cmds = []
        expect { parser.parse { |line| cmds << line } }.not_to output.to_stdout
        expect(cmds).not_to be_empty
      end
    end

    context 'when block is not given' do
      it 'runs default block' do
        described_class.new('./spec/templates/commands.txt', executer).parse
        expect(executer).to have_received(:run).at_least(:once)
      end
    end
  end
end
