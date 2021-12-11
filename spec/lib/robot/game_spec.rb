# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Robot::Game do
  subject(:game) { described_class.new }

  before do
    allow(Robot::Storage).to receive(:fetch)
  end

  describe '.init' do
    it 'fetches game for storage' do
      described_class.init
      expect(Robot::Storage).to have_received(:fetch)
    end
  end

  describe '.fetch' do
    it 'fetches game for storage' do
      described_class.fetch
      expect(Robot::Storage).to have_received(:fetch)
    end
  end

  describe '#report' do
    context 'when toy is placed' do
      before do
        game.place(x_axis: 0, y_axis: 0, direction: 'north')
      end

      it 'reports position of toy' do
        expect { game.report }.to output(/0,0,NORTH/).to_stdout
      end
    end
  end

  describe '#to_positions' do
    context 'when game is valid' do
      before do
        game.place(x_axis: 0, y_axis: 0, direction: 'north')
      end

      it 'returns positions of toy' do
        expect(game.to_positions).to eq([0, 0, 'NORTH'])
      end
    end

    context 'when game toy is not valid' do
      it 'returns nil' do
        expect(game.to_positions).to be_nil
      end
    end
  end

  describe '#move' do
    context 'when game is valid' do
      before do
        game.place(x_axis: 0, y_axis: 0, direction: 'north')
      end

      it 'move the toy one unit to the direction' do
        game.move
        expect(game.to_positions).to eq([0, 1, 'NORTH'])
      end
    end

    context 'when move is in valid' do
      before do
        game.place(x_axis: 0, y_axis: 0, direction: 'west')
      end

      it 'does not move toy' do
        game.move
        expect(game.to_positions).to eq([0, 0, 'WEST'])
      end
    end
  end

  describe '#place' do
    context 'when new toy is valid' do
      it 'sets the toy to game' do
        game.place(x_axis: 0, y_axis: 0, direction: 'north')
        expect(game.toy.x_axis).to eq(0)
      end
    end

    context 'when new toy is invalid' do
      it 'resets the toy' do
        game.place(x_axis: 'invalid', y_axis: 0, direction: 'north')
        expect(game.toy.x_axis).to be_nil
      end
    end

    context 'when toy is nil' do
      it 'invalidates the game' do
        game.toy = nil
        expect { game.validate! }.to raise_error(Robot::Toy::Invalid)
      end
    end
  end

  describe '#save' do
    before do
      allow(Robot::Storage).to receive(:store)
    end

    it 'saves the game' do
      game.place(x_axis: 0, y_axis: 0, direction: 'north')
      game.save
      expect(Robot::Storage).to have_received(:store).with(game)
    end
  end
end
