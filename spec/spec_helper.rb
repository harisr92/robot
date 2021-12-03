# frozen_string_literal: true

ENV['APP_ENV'] = 'test'
require 'bundler'

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

require 'robot'

RSpec.configure do |c|
  c.tty = true

  c.before :each do
    Robot::Storage.reset
  end
end
