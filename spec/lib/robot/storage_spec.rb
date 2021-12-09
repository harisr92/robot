# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Robot::Storage do
  let(:game) { Robot::Game.new }

  describe '.store' do
    it 'stores table' do
      expect(Robot::Game.new.to_positions).to be_nil

      game.place(x_axis: 0, y_axis: 0, direction: 'north')
      described_class.store(game)
      expect(game.to_positions).to eq([0, 0, 'NORTH'])
    end
  end

  describe '.fetch' do
    context 'when the table is created' do
      before do
        described_class.store(game)
        game.place(x_axis: 0, y_axis: 0, direction: 'north')
        game.save
      end

      it 'fetches the table' do
        expect(described_class.fetch.toy).not_to be_nil
      end
    end

    context 'when table is not created' do
      it 'has a new table' do
        expect(described_class.fetch.toy.direction).to be_empty
      end
    end
  end

  describe '.reset' do
    before do
      described_class.store(game)
      game.place(x_axis: 0, y_axis: 0, direction: 'north')
      game.save
    end

    it 'removes table data from storage and recreate the game' do
      expect(described_class.fetch.toy.direction).to eq('north')
      described_class.reset
      expect(described_class.fetch.toy.direction).to be_empty
    end
  end
end
