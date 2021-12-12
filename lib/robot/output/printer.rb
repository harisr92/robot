# frozen_string_literal: true

module Robot
  module Output
    # Printer, to print report
    class Printer
      attr_reader :options

      class << self
        def out(data, options = {})
          new(data, options).print
        end
      end

      def initialize(data, options = {})
        @options = options
        @data = data
      end

      def print
        text = data
        return if text == '' || text.nil?

        shell.puts(text, options[:formats])
      end

      private

      def shell
        @shell = options[:shell] || Shell.new
      end

      def data
        [@data].flatten.compact.join(',')
      end
    end
  end
end
