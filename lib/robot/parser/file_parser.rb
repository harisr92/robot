# frozen_string_literal: true

module Robot
  module Parser
    # FileParser to read and parse file
    class FileParser < Base
      def parse(&block)
        file = path
        return unless File.exist?(file)

        runner = block_given? ? block : default_block
        File.open(file, 'r') do |file_io|
          file_io.each_line(&runner)
        end
      end

      private

      def path
        path = Pathname.new(commands_list)
        if path.absolute?
          path.join(Dir.pwd, path)
        else
          path
        end
      end
    end
  end
end
