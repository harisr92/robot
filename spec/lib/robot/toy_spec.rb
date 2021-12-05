require 'spec_helper'

RSpec.describe Robot::Toy do
  let(:table) { Robot::Table.init }

  describe '.new' do
    context 'when no arguments are passed' do
      it 'should create toy with default arguments' do
        toy = described_class.new
        expect(toy.x_axis).to eq(0)
        expect(toy.y_axis).to eq(0)
        expect(toy.direction).to eq('north')
        expect(toy.table).to be_nil
      end
    end

    context 'when arguments are valid' do
      it 'should initialize toy' do
        toy = described_class.new(x_axis: 0, y_axis: 0, direction: 'north', table: table)
        expect(toy.x_axis).to eq(0)
        expect(toy.y_axis).to eq(0)
        expect(toy.direction).to eq('north')
        expect(toy.table).to eq(table)
      end
    end

    context 'when wrong direction is given' do
      it 'should raise invalid error' do
        err_message = "Invalid direction, WRONG. \nAvailable directions are NORTH, SOUTH, WEST and EAST"
        expect do
          described_class.new(x_axis: 0, y_axis: 0, direction: 'wrong', table: table)
        end.to raise_error(Robot::Toy::Invalid, err_message)
      end
    end

    context 'when wrong x_axis is given' do
      it 'should raise invalid error' do
        err_message = "Invalid position #{Robot.config.table_width + 2},0,NORTH. \n"
        expect do
          described_class.new(x_axis: Robot.config.table_width + 2)
        end.to raise_error(Robot::Toy::Invalid, err_message)
      end
    end

    context 'when wrong y_axis is given' do
      it 'should raise invalid error' do
        err_message = "Invalid position 0,#{Robot.config.table_height + 2},NORTH. \n"
        expect do
          described_class.new(y_axis: Robot.config.table_height + 2)
        end.to raise_error(Robot::Toy::Invalid, err_message)
      end
    end

    context 'when table is invalid' do
      let(:table) { Class.new }

      it 'should raise no method error' do
        expect { described_class.new(table: table) }.to raise_error(NoMethodError)
      end
    end
  end

  describe '#left' do
    subject { described_class.new }

    context 'when facing north' do
      it 'should face west' do
        expect(subject.direction).to eq('north')
        subject.left
        expect(subject.direction).to eq('west')
      end
    end

    context 'when facing west' do
      it 'should face south' do
        subject.left
        expect(subject.direction).to eq('west')
        subject.left
        expect(subject.direction).to eq('south')
      end
    end

    context 'when facing south' do
      it 'should face east' do
        subject.left
        subject.left
        expect(subject.direction).to eq('south')
        subject.left
        expect(subject.direction).to eq('east')
      end
    end

    context 'when facing east' do
      it 'should face north' do
        subject.left
        subject.left
        subject.left
        expect(subject.direction).to eq('east')
        subject.left
        expect(subject.direction).to eq('north')
      end
    end
  end

  describe '#right' do
    context 'when facing north' do
      it 'should face east' do
        expect(subject.direction).to eq('north')
        subject.right
        expect(subject.direction).to eq('east')
      end
    end

    context 'when facing east' do
      it 'should face south' do
        subject.right
        expect(subject.direction).to eq('east')
        subject.right
        expect(subject.direction).to eq('south')
      end
    end

    context 'when facing south' do
      it 'should face west' do
        subject.right
        subject.right
        expect(subject.direction).to eq('south')
        subject.right
        expect(subject.direction).to eq('west')
      end
    end

    context 'when facing west' do
      it 'should face north' do
        subject.right
        subject.right
        subject.right
        expect(subject.direction).to eq('west')
        subject.right
        expect(subject.direction).to eq('north')
      end
    end
  end

  describe '#move' do
    context 'when movements are valid' do
      let(:toy) { Robot::Toy.new(x_axis: 3, y_axis: 3) }

      context 'when direction is facing north' do
        it 'should move one unit north' do
          expect(toy.to_s).to eq('3,3,NORTH')
          toy.move
          expect(toy.to_s).to eq('3,4,NORTH')
        end
      end

      context 'when direction is facing south' do
        it 'should move one unit south' do
          toy.left
          toy.left
          expect(toy.to_s).to eq('3,3,SOUTH')
          toy.move
          expect(toy.to_s).to eq('3,2,SOUTH')
        end
      end

      context 'when direction is facing west' do
        it 'should move one unit north' do
          toy.left
          expect(toy.to_s).to eq('3,3,WEST')
          toy.move
          expect(toy.to_s).to eq('2,3,WEST')
        end
      end

      context 'when direction is facing east' do
        it 'should move one unit north' do
          toy.right
          expect(toy.to_s).to eq('3,3,EAST')
          toy.move
          expect(toy.to_s).to eq('4,3,EAST')
        end
      end
    end

    context 'when there is invalid movement' do
      it 'should raise invalid error' do
        subject.left
        expect(subject.to_s).to eq('0,0,WEST')
        err_message = "Invalid position -1,0,WEST. \nCurrent postion is 0,0,WEST"
        expect { subject.move }.to raise_error(Robot::Toy::Invalid, err_message)
      end
    end
  end
end
