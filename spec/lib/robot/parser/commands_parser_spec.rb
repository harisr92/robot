# frozen_string_literal: true

RSpec.describe Robot::Parser::CommandsParser do
  let(:executer) { class_double(Robot::Executer, run: true) }

  describe '#parse' do
    context 'when block given' do
      it 'executes the supplied block' do
        parser = described_class.new("PLACE 0,0,NORTH\nMOVE\nRIGHT", executer)
        expect { parser.parse { |cmd| puts(cmd) } }.to output.to_stdout
        expect(executer).not_to have_received(:run)
      end
    end

    context 'when block is not provided' do
      it 'executes by the executer' do
        described_class.new("PLACE 0,0,NORTH\nMOVE\nRIGHT", executer).parse
        expect(executer).to have_received(:run).exactly(3).times
      end
    end
  end
end
