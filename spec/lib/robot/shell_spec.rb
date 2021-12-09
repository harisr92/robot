# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Robot::Shell do
  subject(:shell) { described_class.new }

  describe 'puts' do
    it 'calls say in thor shell' do
      expect { shell.puts('Hello World', :red) }.to output(/Hello World/).to_stdout
    end
  end
end
