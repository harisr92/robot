# frozen_string_literal: true

module Robot
  # Storage interface to fetch and store data
  class Storage
    class << self
      def store(game)
        storage.transaction do
          storage[:game] = game
        end
      end

      def fetch
        storage.transaction do
          storage[:game] ||= Game.new
        end
      end

      def reset
        storage.transaction do
          storage.delete(:game)
        end
        fetch
      end

      private

      def storage
        @storage ||= PStore.new('.robot.pstore')
      end
    end
  end
end
