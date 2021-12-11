# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Robot::Toy do
  subject(:toy) { described_class.new(x_axis: 0, y_axis: 0, direction: 'north') }

  let(:game) { Robot::Game.new(Robot::Table.new, toy) }

  describe '.new' do
    context 'when no arguments are passed' do
      it 'creates toy with default arguments' do
        expect(toy.x_axis).to eq(0)
        expect(toy.direction).to eq('north')
      end
    end

    context 'when arguments are valid' do
      it 'initializes toy' do
        expect { game.validate! }.not_to raise_error
        expect(toy.direction).to eq('north')
      end
    end

    context 'when wrong direction is given' do
      it 'raises invalid error' do
        err_message = 'Invalid direction, WRONG'
        game.toy = described_class.new(x_axis: 0, y_axis: 0, direction: 'wrong')
        expect do
          game.validate!
        end.to raise_error(Robot::Toy::Invalid, err_message)
      end
    end

    context 'when wrong x_axis is given' do
      it 'raises invalid error' do
        err_message = "Invalid position #{Robot.config.table_width + 2},0,NORTH"
        game.toy = described_class.new(x_axis: Robot.config.table_width + 2, y_axis: 0, direction: 'north')
        expect do
          game.validate!
        end.to raise_error(Robot::Toy::Invalid, err_message)
      end
    end

    context 'when wrong y_axis is given' do
      it 'raises invalid error' do
        err_message = "Invalid position 0,#{Robot.config.table_height + 2},NORTH"
        game.toy = described_class.new(y_axis: Robot.config.table_height + 2, x_axis: 0, direction: 'north')
        expect do
          game.validate!
        end.to raise_error(Robot::Toy::Invalid, err_message)
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
      let(:toy) { described_class.new(x_axis: 3, y_axis: 3, direction: 'north') }

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
      before do
        game.toy = toy
        toy.left
      end

      it 'raises invalid error' do
        expect(toy.to_s).to eq('0,0,WEST')
        err_message = 'Invalid position -1,0,WEST'
        toy.move
        expect { game.validate! }.to raise_error(Robot::Toy::Invalid, err_message)
      end
    end
  end

  describe '#to_positions' do
    it 'gets position' do
      expect(toy.to_positions).to eq([0, 0, 'NORTH'])
    end
  end

  describe '#place' do
    it 'sets positions and direction to toy' do
      toy.place(x_axis: 1, y_axis: 1, direction: 'east')
      expect(toy.to_positions).to eq([1, 1, 'EAST'])
    end
  end
end
