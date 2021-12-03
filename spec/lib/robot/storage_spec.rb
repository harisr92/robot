require 'spec_helper'

RSpec.describe Robot::Storage do
  let(:table) { Robot::Table.new }

  describe '.store' do
    it 'should store table' do
      expect(Robot::Table.report).to be_empty

      table.place_robot(x_axis: 0, y_axis: 0, direction: 'north')
      described_class.store(table)
      expect(Robot::Table.report).to eq('0,0,NORTH')
    end
  end

  describe '.fetch' do
    context 'when the table is created' do
      before do
        described_class.store(table)
        table.place_robot(x_axis: 0, y_axis: 0, direction: 'north')
      end

      it 'should fetch the table' do
        expect(described_class.fetch.toy).not_to be_nil
      end
    end

    context 'when table is not created' do
      it 'should have a new table' do
        expect(described_class.fetch.toy).to be_nil
      end
    end
  end

  describe '.reset' do
    before do
      described_class.store(table)
      table.place_robot(x_axis: 0, y_axis: 0, direction: 'north')
    end

    it 'should remove table data from storage and recreate the table' do
      expect(described_class.fetch.toy).not_to be_nil
      described_class.reset
      expect(described_class.fetch.toy).to be_nil
    end
  end
end
