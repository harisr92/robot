# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Robot::Table do
  subject(:table) { described_class.init }

  describe '.init' do
    context 'when storage is empty' do
      it 'initializes new data to storage' do
        table = described_class.init
        expect(table).to be_instance_of(described_class)
        expect(table.toy).to be_nil
      end
    end

    context 'when storage have data' do
      before do
        table.toy = Robot::Toy.place(x_axis: 0, y_axis: 0, direction: 'north', table: table)
        table.update
      end

      it 'gives the latest data' do
        table = described_class.init
        expect(table.toy).not_to be_nil
        expect(table.toy.x_axis).to be(0)
      end
    end
  end

  describe '.report' do
    context 'when table is not initialised' do
      it 'returns empty string' do
        expect(described_class.report).to eq('')
      end
    end

    context 'when robot is placed on the table' do
      before do
        table.toy = Robot::Toy.place(x_axis: 0, y_axis: 0, direction: 'north', table: table)
        table.update
      end

      it 'reports position of robot' do
        expect(described_class.report).to eq('0,0,NORTH')
      end
    end
  end

  describe '.new' do
    let(:toy) { instance_double(Robot::Toy) }

    it 'sets correct instance variables' do
      expect(table.width).to eq(Robot.config.table_width)
      table = described_class.new(toy)
      expect(table.toy).to eq(toy)
    end
  end

  describe '#toy' do
    it 'has attribute reader toy' do
      expect(table).to respond_to(:toy)
    end
  end

  describe '#width' do
    it 'has attribute reader width' do
      expect(table).to respond_to(:width)
    end
  end

  describe '#height' do
    it 'has attribute reader height' do
      expect(table).to respond_to(:height)
    end
  end

  describe '#update' do
    before do
      table.toy = Robot::Toy.place(x_axis: 0, y_axis: 0, direction: 'north')
    end

    it 'stores state of the table' do
      expect(described_class.report).to eq('')
      table.update
      expect(described_class.report).to eq('0,0,NORTH')
    end
  end
end
