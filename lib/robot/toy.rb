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
      handle_invalid_direction(direction)

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

    def validate_and_set(new_x, new_y)
      handle_invalid_position(new_x, new_y)

      self.x_axis = new_x
      self.y_axis = new_y
    end

    def handle_invalid_direction(direction)
      return if DIRECTIONS.include?(direction)

      message = "Invalid direction, #{direction.upcase}. \n"
      message << 'Available directions are '
      directions = DIRECTIONS.map(&:upcase)
      message << directions[0..-2].join(', ')
      message << " and #{directions.last}"
      raise Invalid, message
    end

    def handle_invalid_position(new_x, new_y)
      return if valid_x_axis?(new_x) && valid_y_axis?(new_y)

      message = "Invalid position #{new_x},#{new_y},#{direction.upcase}. \n"
      message << "Current postion is #{self}" if x_axis && y_axis
      raise Invalid, message
    end

    def valid_x_axis?(new_x)
      width = table&.width || Robot.config.table_width
      new_x >= 0 && new_x <= width
    end

    def valid_y_axis?(new_y)
      height = table&.height || Robot.config.table_height
      new_y >= 0 && new_y <= height
    end
  end
end
