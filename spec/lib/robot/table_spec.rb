# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Robot::Table do
  subject(:table) { described_class.new }

  describe '.new' do
    it 'sets correct instance variables' do
      expect(table.width).to eq(Robot.config.table_width)
    end
  end
end
