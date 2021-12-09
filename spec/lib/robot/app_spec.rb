# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Robot::App do
  subject(:app) { described_class.new }

  let(:shell) { $stdout }

  # rubocop:disable RSpec/ExpectOutput
  before do
    $stdout = File.open(File::NULL, 'w')
  end

  after do
    $stdout = shell
  end
  # rubocop:enable RSpec/ExpectOutput

  it 'has right namespace' do
    expect(described_class.namespace).to eq('robot')
  end

  describe '.exit_on_failure?' do
    it 'is true' do
      expect(described_class).to be_exit_on_failure
    end
  end

  describe '#console' do
    before do
      allow(Pry).to receive(:start)
    end

    it 'starts a pry instance' do
      app.invoke(:console)
      expect(Pry).to have_received(:start)
    end
  end

  describe '#execute' do
    before do
      allow(Robot::Table).to receive(:report)
    end

    context 'when commands is passed' do
      context 'when valid commands are passed' do
        it 'executes every command' do
          app.invoke(:execute, [], commands: "PLACE 0,0,NORTH\n RIGHT\n REPORT\n MOVE\n LEFT\n LEFT")
          table = Robot::Table.init
          expect(table.toy.to_s).to eq('1,0,WEST')
        end
      end

      context 'when commands are not valid' do
        it 'skips rest commands when robot is not place' do
          app.invoke(:execute, [], commands: "RIGHT\n REPORT\n MOVE\n LEFT\n LEFT")
          table = Robot::Table.init
          expect(table.toy.to_s).to eq('')
        end

        it 'skips when two commands are on same line' do
          app.invoke(:execute, [], commands: "PLACE 0,0,NORTH\n RIGHT\n REPORT\n MOVE LEFT\n LEFT")
          table = Robot::Table.init
          expect(table.toy.to_s).to eq('1,0,NORTH')
        end

        it 'skips when command is invalid' do
          app.invoke(:execute, [], commands: "PLACE 0,0,NORTH\n RIGHT\n REPORT\n MOVE\n LEFT\n LET")
          table = Robot::Table.init
          expect(table.toy.to_s).to eq('1,0,NORTH')
        end
      end
    end

    context 'when file is passed' do
      it 'reads commands from file' do
        app.invoke(:execute, [], file: "#{__dir__}/../../templates/commands.txt")
        table = Robot::Table.init
        expect(table.toy.to_s).to eq('0,1,WEST')
      end

      context 'when path is not valid' do
        it 'does not do anything' do
          app.invoke(:execute, [], file: './commands.txt')
          table = Robot::Table.init
          expect(table.toy.to_s).to eq('')
        end

        it 'runs all commands when large file is passed' do
          app.invoke(:execute, [], file: "#{__dir__}/../../templates/large_commands_set.txt")
          table = Robot::Table.init
          expect(table.toy.to_s).to eq('5,3,NORTH')
        end
      end
    end
  end

  describe '#reset' do
    it 'resets table' do
      app.invoke(:execute, [], commands: 'PLACE 0,0,NORTH')
      expect(Robot::Table.report).to eq('0,0,NORTH')
      app.reset
      expect(Robot::Table.report).to eq('')
    end
  end
end
