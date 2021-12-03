require 'spec_helper'

RSpec.describe Robot::App do
  it 'should be a thor app' do
    expect(described_class.superclass).to eq(Thor)
  end

  it 'should have right namespace' do
    expect(described_class.namespace).to eq('robot')
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
          subject.invoke(:place, ['3,3,INVALID'])
          expect(Robot::Table.init.toy.to_s).to eq('')
        end
      end

      context 'when wrong axis data is given' do
        it 'should ignore the data' do
          subject.invoke(:place, ['3,3000,SOUTH'])
          expect(Robot::Table.init.toy.to_s).to eq('')
        end
      end

      context 'when less arguments are passed' do
        it 'should ignore data' do
          subject.invoke(:place, ['3,3000'])
          expect(Robot::Table.init.toy.to_s).to eq('')
        end
      end
    end
  end

  describe '#report' do
    before do
      allow(Robot::Table).to receive(:report)
    end

    it 'should get report from table' do
      expect(Robot::Table).to receive(:report)
      subject.invoke(:report)
    end
  end
end
