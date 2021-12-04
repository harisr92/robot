# frozen_string_literal: true

module Robot
  # table for toy robot to move
  class Table
    attr_reader :width, :height
    attr_accessor :toy

    class << self
      def init
        fetch
      end

      def report
        table = fetch
        table.toy.to_s
      end

      private

      def fetch
        Storage.fetch
      end
    end

    def initialize(toy = nil)
      @toy = toy
      @width = Robot.config.table_width || 5
      @height = Robot.config.table_height || 5
    end

    def place_robot(**args)
      self.toy = Toy.new(**args, table: self)
    end

    def update
      Storage.store(self)
    end
  end
end
