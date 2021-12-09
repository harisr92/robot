# frozen_string_literal: true

module Robot
  # Shell to output message
  class Shell < Thor::Shell::Color
    def puts(*args)
      say(*args)
    end
  end
end
