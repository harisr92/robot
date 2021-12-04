require 'spec_helper'

RSpec.describe Robot::Table do
  describe '.init' do
    context 'when storage is empty' do
      it 'should initialize new data to storage' do
        table = described_class.init
        expect(table).to be_instance_of(described_class)
        expect(table.toy).to be_nil
      end
    end

    context 'when storage have data' do
      before do
        subject.place_robot(x_axis: 0, y_axis: 0, direction: 'north')
        subject.update
      end

      it 'should give the latest data' do
        table = described_class.init
        expect(table.toy).not_to be_nil
        expect(table.toy.x_axis).to be(0)
        expect(table.toy.direction).to eq('north')
      end
    end
  end

  describe '.report' do
    context 'when table is not initialised' do
      it 'should return empty string' do
        expect(described_class.report).to eq('')
      end
    end

    context 'when robot is placed on the table' do
      before do
        subject.place_robot(x_axis: 0, y_axis: 0, direction: 'north')
        subject.update
      end

      it 'should report position of robot' do
        expect(described_class.report).to eq('0,0,NORTH')
      end
    end
  end

  describe '.new' do
    let(:toy) { double(:toy) }

    it 'should set correct instance variables' do
      expect(subject.width).to eq(Robot.config.table_width)
      expect(subject.height).to eq(Robot.config.table_height)
      expect(subject.toy).to be_nil
      table = Robot::Table.new(toy)
      expect(table.toy).to eq(toy)
    end
  end

  describe '#toy' do
    it 'should have attribute reader toy' do
      expect(subject).to respond_to(:toy)
    end
  end

  describe '#width' do
    it 'should have attribute reader width' do
      expect(subject).to respond_to(:width)
    end
  end

  describe '#height' do
    it 'should have attribute reader height' do
      expect(subject).to respond_to(:height)
    end
  end

  describe '#place_robot' do
    let(:table) { Robot::Table.init }

    context 'when arguments are x_axis, y_axis and direction' do
      it 'should create a toy' do
        toy = table.place_robot(x_axis: 0, y_axis: 0, direction: 'north')
        expect(toy.table).to eq(table)
        expect(toy.x_axis).to eq(0)
        expect(toy.direction).to eq('north')
      end
    end

    context 'when invalid params are send' do
      it 'should raise error' do
        expect { table.place_robot([]) }.to raise_error(ArgumentError)
        expect { table.place_robot(x_axis: -20, y_axis: -20) }.to raise_error(Robot::Toy::Invalid)
        expect { table.place_robot(direction: 'test') }.to raise_error(Robot::Toy::Invalid)
      end
    end
  end

  describe '#update' do
    before do
      subject.place_robot(x_axis: 0, y_axis: 0, direction: 'north')
    end

    it 'should store state of the table' do
      expect(Robot::Table.report).to eq('')
      subject.update
      expect(Robot::Table.report).to eq('0,0,NORTH')
    end
  end
end
