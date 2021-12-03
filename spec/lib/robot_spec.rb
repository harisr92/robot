# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Robot do
  it 'should have version' do
    expect(Robot::VERSION).to eq('0.0.1')
  end

  it 'should have configuration' do
    expect(described_class).to respond_to(:config)
  end

  describe '.config' do
    it 'should have table_height as 5' do
      expect(described_class.config.table_height).to eq(5)
    end

    it 'should have table_width as 5' do
      expect(described_class.config.table_width).to eq(5)
    end

    context 'when configuration is changed' do
      before do
        Robot.configure do |config|
          config.table_height = 10
          config.table_width = 10
        end
      end

      it 'should have table_height from config' do
        expect(described_class.config.table_height).to eq(10)
      end

      it 'should have table_width from config' do
        expect(described_class.config.table_width).to eq(10)
      end
    end
  end
end
