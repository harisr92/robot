# frozen_string_literal: true

module Robot
  # Game, store and fetch details
  class Game
    extend Forwardable

    attr_accessor :table, :toy, :printer

    def_delegators :toy, :left, :right

    class << self
      extend Forwardable

      def_delegators 'Robot::Storage', :fetch

      alias init fetch
    end

    def initialize(table = nil, toy = nil, options = {})
      @table = table
      @toy = toy || Toy.new
      @validator = options[:validator] || Validator
      @printer = options[:printer] || Output::Printer
    end

    def to_positions
      return unless validator_obj.valid?

      toy.to_positions
    end

    def report(*_)
      printer.out(to_positions, formats: %i[on_white bold black])
    end

    def move(*_)
      return unless toy

      t = toy.dup
      toy.move
      self.toy = t unless validator_obj.valid?
    end

    def place(**args)
      t = toy
      self.toy = Toy.place(**args)
      self.toy = t unless validator_obj.valid?
    end

    def save
      Storage.store(self)
    end

    def validate!
      @validator.call(self)
    end

    def validator_obj
      @validator_obj ||= @validator.new(self)
    end
  end
end
