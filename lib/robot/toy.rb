# frozen_string_literal: true

module Robot
  # Robot toy moving on top of table
  class Toy
    class Invalid < StandardError; end

    DIRECTION_MOVES = {
      north: { left: 'west', right: 'east' },
      south: { left: 'east', right: 'west' },
      west: { left: 'south', right: 'north' },
      east: { left: 'north', right: 'south' }
    }.freeze

    attr_reader :direction, :table
    attr_accessor :x_axis, :y_axis

    class << self
      def place(**args)
        t = new(**args)
        t.validate!
        t
      end
    end

    def initialize(x_axis: 0, y_axis: 0, direction: 'north', table: nil)
      @direction = direction
      @table = table
      @x_axis = x_axis
      @y_axis = y_axis
    end

    def place(x_axis: 0, y_axis: 0, direction: 'north', table: nil)
      @direction = direction
      @table = table
      self.x_axis = x_axis
      self.y_axis = y_axis
      validate!
    end

    def left(*_)
      @direction = DIRECTION_MOVES[direction.to_sym][:left]
      nil
    end

    def right(*_)
      @direction = DIRECTION_MOVES[direction.to_sym][:right]
      nil
    end

    # rubocop:disable Metrics/MethodLength
    def move(*_)
      new_x = x_axis.to_i
      new_y = y_axis.to_i
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

      nil
    end
    # rubocop:enable Metrics/MethodLength

    def to_s(*_)
      "#{x_axis},#{y_axis},#{direction.upcase}"
    end

    def to_positions(*_)
      [x_axis, y_axis, direction.upcase]
    end
    alias report to_positions

    def validate!
      handle_invalid_direction(direction)
      handle_invalid_position(x_axis, y_axis)

      self.x_axis = x_axis.to_i
      self.y_axis = y_axis.to_i
      nil
    end

    private

    def validate_and_set(new_x, new_y)
      handle_invalid_position(new_x, new_y)

      self.x_axis = new_x
      self.y_axis = new_y
    end

    def handle_invalid_direction(direction)
      return if DIRECTION_MOVES.keys.include?(direction.to_sym)

      message = "Invalid direction, #{direction.upcase}. \n"
      message << 'Available directions are '
      directions = DIRECTION_MOVES.keys.map { |move| move.to_s.upcase }
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
      return false unless new_x.to_s !~ /\D/

      new_x = new_x.to_i
      width = table&.width || Robot.config.table_width
      new_x >= 0 && new_x <= width
    end

    def valid_y_axis?(new_y)
      return false unless new_y.to_s !~ /\D/

      new_y = new_y.to_i
      height = table&.height || Robot.config.table_height
      new_y >= 0 && new_y <= height
    end
  end
end
