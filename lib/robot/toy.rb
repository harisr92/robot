# frozen_string_literal: true

module Robot
  # Robot toy moving on top of table
  class Toy
    class Invalid < StandardError; end

    DIRECTIONS = %w[north south west east].freeze
    DIRECTION_MOVES = {
      north: { left: 'west', right: 'east' },
      south: { left: 'east', right: 'west' },
      west: { left: 'south', right: 'north' },
      east: { left: 'north', right: 'south' }
    }.freeze

    attr_reader :direction, :table
    attr_accessor :x_axis, :y_axis

    def initialize(x_axis: 0, y_axis: 0, direction: 'north', table: nil)
      raise Invalid, "not a valid direction #{direction.upcase}" unless DIRECTIONS.include?(direction)

      @direction = direction
      @table = table
      validate_and_set(x_axis, y_axis)
    end

    def left
      @direction = DIRECTION_MOVES[direction.to_sym][:left]
    end

    def right
      @direction = DIRECTION_MOVES[direction.to_sym][:right]
    end

    # rubocop:disable Metrics/MethodLength
    def move
      new_y = y_axis
      new_x = x_axis
      case direction
      when 'north'
        new_y += 1
      when 'south'
        new_y -= 1
      when 'west'
        new_x -= 1
      when 'east'
        new_x += 1
      end
      validate_and_set(new_x, new_y)
    end
    # rubocop:enable Metrics/MethodLength

    def to_s
      "#{x_axis},#{y_axis},#{direction.upcase}"
    end

    private

    def validate_and_set(x_axis, y_axis)
      validate_x_axis(x_axis)
      validate_y_axis(y_axis)
    end

    def validate_x_axis(x_axis)
      width = table&.width || Robot.config.table_width
      raise Invalid, "Invalid x-axis #{x_axis}" unless x_axis >= 0 && x_axis <= width

      self.x_axis = x_axis
    end

    def validate_y_axis(y_axis)
      height = table&.height || Robot.config.table_height
      raise Invalid, "Invalid y-axis #{y_axis}" unless y_axis >= 0 && y_axis <= height

      self.y_axis = y_axis
    end
  end
end
