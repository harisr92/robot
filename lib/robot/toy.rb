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

    attr_accessor :x_axis, :y_axis, :direction

    class << self
      def place(**args)
        new(**args)
      end
    end

    def initialize(x_axis: nil, y_axis: nil, direction: '')
      @direction = direction
      @x_axis = x_axis
      @y_axis = y_axis
    end

    def place(x_axis: 0, y_axis: 0, direction: 'north')
      self.direction = direction
      self.x_axis = x_axis
      self.y_axis = y_axis
    end

    def left(*_)
      @direction = (DIRECTION_MOVES[direction.to_sym] || {})[:left] || direction
    end

    def right(*_)
      @direction = (DIRECTION_MOVES[direction.to_sym] || {})[:right] || direction
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
      self.x_axis = new_x
      self.y_axis = new_y
    end
    # rubocop:enable Metrics/MethodLength

    def to_s(*_)
      "#{x_axis},#{y_axis},#{direction.upcase}"
    end

    def to_positions(*_)
      [x_axis.to_i, y_axis.to_i, direction.upcase]
    end
  end
end
