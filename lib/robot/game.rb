# frozen_string_literal: true

module Robot
  # Game, store and fetch details
  class Game
    extend Forwardable

    attr_accessor :table, :toy

    def_delegators :toy, :left, :right, :move

    class << self
      def init
        fetch
      end

      private

      def fetch
        Storage.fetch
      end
    end

    def initialize(table = nil, toy = nil, options = {})
      @table = table
      @toy = toy || Toy.new
      @validator = options[:validator] || Validator
      @printer = options[:printer] || Output::Printer
    end

    def report(*_)
      @printer.out(data: to_positions, formats: %i[on_white bold black])
    end

    def to_positions
      return unless validator_obj.valid?

      toy.to_positions
    end

    def place(**args)
      self.toy = Toy.place(**args)
    end

    def save
      Storage.store(self)
    end

    def validate!
      return unless toy

      @validator.call(self)
    end

    def validator_obj
      @validator_obj ||= @validator.new(self)
    end
  end
end
