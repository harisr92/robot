# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Robot do
  it 'has version' do
    expect(Robot::VERSION).to eq('0.0.1')
  end

  it 'has configuration' do
    expect(described_class).to respond_to(:config)
  end

  describe '.config' do
    it 'has table_height as 5' do
      expect(described_class.config.table_height).to eq(5)
    end

    it 'has table_width as 5' do
      expect(described_class.config.table_width).to eq(5)
    end

    context 'when configuration is changed' do
      before do
        described_class.configure do |config|
          config.table_height = 10
          config.table_width = 10
        end
      end

      it 'has table_height from config' do
        expect(described_class.config.table_height).to eq(10)
      end

      it 'has table_width from config' do
        expect(described_class.config.table_width).to eq(10)
      end
    end
  end
end
