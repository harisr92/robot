# frozen_string_literal: true

module Robot
  # validator for toy
  class Validator < SimpleDelegator
    def self.call(game)
      new(game).validate!
    end

    def valid?
      handle_invalid_direction && handle_invalid_position
    end

    def validate!
      return true if valid?

      raise Toy::Invalid, @message
    end

    def handle_invalid_direction
      return true if Toy::DIRECTION_MOVES.keys.include?(toy.direction.to_sym)

      @message = "Invalid direction, #{toy.direction.upcase}"
      false
    end

    def handle_invalid_position
      return true if valid_x_axis? && valid_y_axis?

      @message = "Invalid position #{toy.x_axis},#{toy.y_axis},#{toy.direction.upcase}"
      false
    end

    def valid_x_axis?
      return false unless toy.x_axis.to_s !~ /\D/

      new_x = toy.x_axis.to_i
      width = table&.width || Robot.config.table_width
      new_x >= 0 && new_x <= width
    end

    def valid_y_axis?
      return false unless toy.y_axis.to_s !~ /\D/

      new_y = toy.y_axis.to_i
      height = table&.height || Robot.config.table_height
      new_y >= 0 && new_y <= height
    end
  end
end
