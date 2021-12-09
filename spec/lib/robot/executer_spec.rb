# frozen_string_literal: true

RSpec.describe Robot::Executer do
  def build_subject(cmd, game)
    Robot::Executer.new(cmd, game, Robot::Toy, File.open(File::NULL, 'w'))
  end

  describe '#run' do
    context 'when command is not empty string' do
      it 'executes the commands' do
        exec = build_subject('PLACE 0,0,NORTH', Robot::Game.init)
        exec.run
        expect(Robot::Game.init.to_positions).to eq([0, 0, 'NORTH'])
      end
    end
  end
end
