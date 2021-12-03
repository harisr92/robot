# frozen_string_literal: true

module Robot
  # Storage interface to fetch and store data
  class Storage
    class << self
      def store(table)
        storage.transaction do
          storage[:table] = table
        end
      end

      def fetch
        storage.transaction do
          storage[:table] ||= Table.new
        end
      end

      def reset
        storage.transaction do
          storage.delete(:table)
        end
        fetch
      end

      private

      def storage
        @storage ||= PStore.new('robot.pstore')
      end
    end
  end
end
