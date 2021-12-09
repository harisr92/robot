# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Robot::Toy do
  subject(:toy) { described_class.new }

  let(:table) { Robot::Table.init }

  describe '.new' do
    context 'when no arguments are passed' do
      it 'creates toy with default arguments' do
        expect(toy.x_axis).to eq(0)
        expect(toy.direction).to eq('north')
      end
    end

    context 'when arguments are valid' do
      subject(:toy) { described_class.new(table: table) }

      it 'initializes toy' do
        expect(toy.direction).to eq('north')
        expect(toy.table).to eq(table)
      end
    end

    context 'when wrong direction is given' do
      it 'raises invalid error' do
        err_message = "Invalid direction, WRONG. \nAvailable directions are NORTH, SOUTH, WEST and EAST"
        toy = described_class.new(x_axis: 0, y_axis: 0, direction: 'wrong', table: table)
        expect do
          toy.validate!
        end.to raise_error(Robot::Toy::Invalid, err_message)
      end
    end

    context 'when wrong x_axis is given' do
      it 'raises invalid error' do
        err_message = "Invalid position #{Robot.config.table_width + 2},0,NORTH. \nCurrent postion is 7,0,NORTH"
        toy = described_class.new(x_axis: Robot.config.table_width + 2)
        expect do
          toy.validate!
        end.to raise_error(Robot::Toy::Invalid, err_message)
      end
    end

    context 'when wrong y_axis is given' do
      it 'raises invalid error' do
        err_message = "Invalid position 0,#{Robot.config.table_height + 2},NORTH. \nCurrent postion is 0,7,NORTH"
        toy = described_class.new(y_axis: Robot.config.table_height + 2)
        expect do
          toy.validate!
        end.to raise_error(Robot::Toy::Invalid, err_message)
      end
    end

    context 'when table is invalid' do
      let(:table) { Class.new }

      it 'raises no method error' do
        toy = described_class.new(table: table)
        expect { toy.validate! }.to raise_error(NoMethodError)
      end
    end
  end

  describe '#left' do
    context 'when facing north' do
      it 'faces west' do
        expect(toy.direction).to eq('north')
        toy.left
        expect(toy.direction).to eq('west')
      end
    end

    context 'when facing west' do
      it 'faces south' do
        toy.left
        expect(toy.direction).to eq('west')
        toy.left
        expect(toy.direction).to eq('south')
      end
    end

    context 'when facing south' do
      it 'faces east' do
        toy.left
        toy.left
        expect(toy.direction).to eq('south')
        toy.left
        expect(toy.direction).to eq('east')
      end
    end

    context 'when facing east' do
      before do
        toy.left
        toy.left
        toy.left
      end

      it 'faces north' do
        expect(toy.direction).to eq('east')
        toy.left
        expect(toy.direction).to eq('north')
      end
    end
  end

  describe '#right' do
    context 'when facing north' do
      it 'faces east' do
        expect(toy.direction).to eq('north')
        toy.right
        expect(toy.direction).to eq('east')
      end
    end

    context 'when facing east' do
      it 'faces south' do
        toy.right
        expect(toy.direction).to eq('east')
        toy.right
        expect(toy.direction).to eq('south')
      end
    end

    context 'when facing south' do
      it 'faces west' do
        toy.right
        toy.right
        expect(toy.direction).to eq('south')
        toy.right
        expect(toy.direction).to eq('west')
      end
    end

    context 'when facing west' do
      before do
        toy.left
      end

      it 'faces north' do
        expect(toy.direction).to eq('west')
        toy.right
        expect(toy.direction).to eq('north')
      end
    end
  end

  describe '#move' do
    context 'when movements are valid' do
      let(:toy) { described_class.new(x_axis: 3, y_axis: 3) }

      context 'when direction is facing north' do
        it 'moves one unit north' do
          expect(toy.to_s).to eq('3,3,NORTH')
          toy.move
          expect(toy.to_s).to eq('3,4,NORTH')
        end
      end

      context 'when direction is facing south' do
        it 'moves one unit south' do
          toy.left
          toy.left
          expect(toy.to_s).to eq('3,3,SOUTH')
          toy.move
          expect(toy.to_s).to eq('3,2,SOUTH')
        end
      end

      context 'when direction is facing west' do
        it 'moves one unit north' do
          toy.left
          expect(toy.to_s).to eq('3,3,WEST')
          toy.move
          expect(toy.to_s).to eq('2,3,WEST')
        end
      end

      context 'when direction is facing east' do
        it 'moves one unit north' do
          toy.right
          expect(toy.to_s).to eq('3,3,EAST')
          toy.move
          expect(toy.to_s).to eq('4,3,EAST')
        end
      end
    end

    context 'when there is invalid movement' do
      it 'raises invalid error' do
        toy.left
        expect(toy.to_s).to eq('0,0,WEST')
        err_message = "Invalid position -1,0,WEST. \nCurrent postion is 0,0,WEST"
        expect { toy.move }.to raise_error(Robot::Toy::Invalid, err_message)
      end
    end
  end

  describe '#to_positions' do
    it 'gets position' do
      expect(toy.to_positions).to eq([0, 0, 'NORTH'])
    end
  end
end
