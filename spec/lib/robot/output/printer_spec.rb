# frozen_string_literal: true

RSpec.describe Robot::Output::Printer do
  let(:shell) { instance_double(Robot::Shell, puts: nil) }

  describe '.out' do
    it 'prints the input data' do
      described_class.out(data: 'Hello World', formats: :red, shell: shell)
      expect(shell).to have_received(:puts).with('Hello World', :red)
    end
  end

  describe '#print' do
    context 'when data is empty' do
      subject(:printer) { described_class.new(data: '', formats: :red, shell: shell) }

      it 'prints nothing' do
        printer.print
        expect(shell).not_to have_received(:puts)
      end
    end

    context 'when data is nil' do
      subject(:printer) { described_class.new(formats: :red, shell: shell) }

      it 'prints nothing' do
        printer.print
        expect(shell).not_to have_received(:puts)
      end
    end

    context 'when data is present' do
      subject(:printer) { described_class.new(data: 'Hello World', formats: :red, shell: shell) }

      it 'prints nothing' do
        printer.print
        expect(shell).to have_received(:puts).with('Hello World', :red)
      end
    end
  end
end
