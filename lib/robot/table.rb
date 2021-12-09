# frozen_string_literal: true

module Robot
  # table for toy robot to move
  class Table
    attr_reader :width, :height

    def initialize
      @width = Robot.config.table_width || 5
      @height = Robot.config.table_height || 5
    end
  end
end
