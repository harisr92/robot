# frozen_string_literal: true

# lib/shell.rb

module Robot
  module Output
    # Printer, to print report
    class Printer
      attr_reader :options

      class << self
        def out(options = {})
          new(options).print
        end
      end

      def initialize(options = {})
        @options = options
      end

      def print
        text = data
        return if text == '' || text.nil?

        shell.puts(data, options[:formats])
      end

      def shell
        @shell = options[:shell] || Shell.new
      end

      def data
        [options[:data]].flatten.compact.join(',')
      end
    end
  end
end
