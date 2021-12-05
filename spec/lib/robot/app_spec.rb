require 'spec_helper'

RSpec.describe Robot::App do
  def shell_expect
    expect_any_instance_of(Thor::Shell::Basic)
  end

  before do
    allow_any_instance_of(Thor::Shell::Basic).to receive(:say)
  end

  it 'should be a thor app' do
    expect(described_class.superclass).to eq(Thor)
  end

  it 'should have right namespace' do
    expect(described_class.namespace).to eq('robot')
  end

  describe '.exit_on_failure?' do
    it 'should be true' do
      expect(described_class.exit_on_failure?).to be_truthy
    end
  end

  describe '#console' do
    before do
      allow(Pry).to receive(:start)
    end

    it 'should start a pry instance' do
      expect(Pry).to receive(:start)
      subject.invoke(:console)
    end
  end

  describe '#place' do
    context 'when arguments are valid' do
      it 'should put robot on position' do
        subject.invoke(:place, ['3,3,NORTH'])
        table = Robot::Table.init
        expect(table.toy.to_s).to eq('3,3,NORTH')
      end
    end

    context 'when wrong arguments are passed' do
      context 'when direction is wrong' do
        it 'should have empty report' do
          shell_expect.to receive(:say).with("Invalid direction, INVALID. \nAvailable directions are NORTH, SOUTH, WEST and EAST", :red)
          subject.invoke(:place, ['3,3,INVALID'])
          expect(Robot::Table.init.toy.to_s).to eq('')
        end
      end

      context 'when wrong axis data is given' do
        it 'should ignore the data' do
          shell_expect.to receive(:say).with("Invalid position 3,3000,SOUTH. \n", :red)
          subject.invoke(:place, ['3,3000,SOUTH'])
          expect(Robot::Table.init.toy.to_s).to eq('')
        end
      end

      context 'when less arguments are passed' do
        it 'should ignore data' do
          shell_expect.to receive(:say).with("Invalid direction, . \nAvailable directions are NORTH, SOUTH, WEST and EAST", :red)
          subject.invoke(:place, ['3,3000'])
          expect(Robot::Table.init.toy.to_s).to eq('')
        end
      end
    end
  end

  describe '#report' do
    let(:table) { Robot::Table.init }

    before do
      table.place_robot(x_axis: 1, y_axis: 1, direction: 'north')
      table.update
    end

    it 'should get report from table' do
      expect_any_instance_of(Thor::Shell::Basic).to receive(:say).with(table.toy.to_s, %i[bold white on_black])
      subject.invoke(:report)
    end
  end

  describe '#left' do
    let(:table) { Robot::Table.init }

    before do
      table.place_robot(x_axis: 0, y_axis: 1)
      table.update
    end

    context 'when facing north' do
      it 'should face west' do
        expect(Robot::Table.report).to eq('0,1,NORTH')
        subject.invoke(:left)
        expect(Robot::Table.report).to eq('0,1,WEST')
      end
    end

    context 'when facing west' do
      it 'should face south' do
        subject.left
        expect(Robot::Table.report).to eq('0,1,WEST')
        subject.invoke(:left)
        expect(Robot::Table.report).to eq('0,1,SOUTH')
      end
    end

    context 'when facing south' do
      it 'should face east' do
        subject.left
        subject.left
        expect(Robot::Table.report).to eq('0,1,SOUTH')
        subject.invoke(:left)
        expect(Robot::Table.report).to eq('0,1,EAST')
      end
    end

    context 'when facing east' do
      it 'should face north' do
        subject.left
        subject.left
        subject.left
        expect(Robot::Table.report).to eq('0,1,EAST')
        subject.invoke(:left)
        expect(Robot::Table.report).to eq('0,1,NORTH')
      end
    end
  end

  describe '#right' do
    let(:table) { Robot::Table.init }

    before do
      table.place_robot(x_axis: 0, y_axis: 1)
      table.update
    end

    context 'when facing north' do
      it 'should face east' do
        expect(Robot::Table.report).to eq('0,1,NORTH')
        subject.invoke(:right)
        expect(Robot::Table.report).to eq('0,1,EAST')
      end
    end

    context 'when facing east' do
      it 'should face south' do
        subject.right
        expect(Robot::Table.report).to eq('0,1,EAST')
        subject.invoke(:right)
        expect(Robot::Table.report).to eq('0,1,SOUTH')
      end
    end

    context 'when facing south' do
      it 'should face west' do
        subject.right
        subject.right
        expect(Robot::Table.report).to eq('0,1,SOUTH')
        subject.invoke(:right)
        expect(Robot::Table.report).to eq('0,1,WEST')
      end
    end

    context 'when facing WEST' do
      it 'should face north' do
        subject.right
        subject.right
        subject.right
        expect(Robot::Table.report).to eq('0,1,WEST')
        subject.invoke(:right)
        expect(Robot::Table.report).to eq('0,1,NORTH')
      end
    end
  end

  describe '#move' do
    let(:table) { Robot::Table.init }

    context 'when facing north' do
      before do
        table.place_robot(x_axis: 2, y_axis: 2, direction: 'north')
      end

      it 'should move one unit north' do
        expect(table.toy.to_s).to eq('2,2,NORTH')
        table.toy.move
        expect(table.toy.to_s).to eq('2,3,NORTH')
      end

      context 'when invalid movement' do
        before do
          subject.place("0,#{Robot.config.table_height},NORTH")
        end

        it 'should raise invalid error' do
          expect(Robot::Table.report).to eq("0,#{Robot.config.table_height},NORTH")
          subject.move
          expect(Robot::Table.report).to eq("0,#{Robot.config.table_height},NORTH")
        end
      end
    end

    context 'when facing south' do
      before do
        table.place_robot(x_axis: 2, y_axis: 2, direction: 'south')
      end

      it 'should move one unit south' do
        expect(table.toy.to_s).to eq('2,2,SOUTH')
        table.toy.move
        expect(table.toy.to_s).to eq('2,1,SOUTH')
      end

      context 'when invalid movement' do
        before do
          table.place_robot(x_axis: 0, y_axis: 0, direction: 'south')
        end

        it 'should raise invalid error' do
          expect { table.toy.move }.to raise_error(Robot::Toy::Invalid)
        end
      end
    end

    context 'when facing west' do
      before do
        table.place_robot(x_axis: 2, y_axis: 2, direction: 'west')
      end

      it 'should move one unit west' do
        expect(table.toy.to_s).to eq('2,2,WEST')
        table.toy.move
        expect(table.toy.to_s).to eq('1,2,WEST')
      end

      context 'when invalid movement' do
        before do
          table.place_robot(x_axis: 0, y_axis: 0, direction: 'south')
        end

        it 'should raise invalid error' do
          expect { table.toy.move }.to raise_error(Robot::Toy::Invalid)
        end
      end
    end

    context 'when facing east' do
      before do
        table.place_robot(x_axis: 2, y_axis: 2, direction: 'east')
      end

      it 'should move one unit west' do
        expect(table.toy.to_s).to eq('2,2,EAST')
        table.toy.move
        expect(table.toy.to_s).to eq('3,2,EAST')
      end

      context 'when invalid movement' do
        before do
          table.place_robot(x_axis: Robot.config.table_width, y_axis: 0, direction: 'east')
        end

        it 'should raise invalid error' do
          expect { table.toy.move }.to raise_error(Robot::Toy::Invalid)
        end
      end
    end
  end

  describe '#execute' do
    before do
      allow(Robot::Table).to receive(:report)
    end

    context 'when conf is passed' do
      context 'when valid commands are passed' do
        it 'should execute every command' do
          expect(Robot::Table).to receive(:report)
          subject.invoke(:execute, [], conf: "PLACE 0,0,NORTH\n RIGHT\n REPORT\n MOVE\n LEFT\n LEFT")
          table = Robot::Table.init
          expect(table.toy.to_s).to eq('1,0,WEST')
        end
      end

      context 'when commands are not valid' do
        it 'should skip rest commands when robot is not place' do
          subject.invoke(:execute, [], conf: "RIGHT\n REPORT\n MOVE\n LEFT\n LEFT")
          table = Robot::Table.init
          expect(table.toy.to_s).to eq('')
        end

        it 'should skip when two commands are on same line' do
          subject.invoke(:execute, [], conf: "PLACE 0,0,NORTH\n RIGHT\n REPORT\n MOVE LEFT\n LEFT")
          table = Robot::Table.init
          expect(table.toy.to_s).to eq('1,0,NORTH')
        end

        it 'should skip when command is invalid' do
          subject.invoke(:execute, [], conf: "PLACE 0,0,NORTH\n RIGHT\n REPORT\n MOVE\n LEFT\n LET")
          table = Robot::Table.init
          expect(table.toy.to_s).to eq('1,0,NORTH')
        end
      end
    end

    context 'when file is passed' do
      it 'should read commands from file' do
        subject.invoke(:execute, [], file: "#{__dir__}/../../templates/commands.txt")
        table = Robot::Table.init
        expect(table.toy.to_s).to eq('0,1,WEST')
      end

      context 'when path is not valid' do
        it 'should not do anything' do
          subject.invoke(:execute, [], file: './commands.txt')
          table = Robot::Table.init
          expect(table.toy.to_s).to eq('')
        end

        it 'should run all commands when large file is passed' do
          subject.invoke(:execute, [], file: "#{__dir__}/../../templates/large_commands_set.txt")
          table = Robot::Table.init
          expect(table.toy.to_s).to eq('5,3,NORTH')
        end
      end
    end
  end

  describe '#reset' do
    it 'should reset table' do
      subject.place('0,0,NORTH')
      expect(Robot::Table.report).to eq('0,0,NORTH')
      subject.reset
      expect(Robot::Table.report).to eq('')
    end
  end
end
