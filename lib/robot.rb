# frozen_string_literal: true

require 'rubygems'
require 'bundler/setup'
Bundler.require(:default, ENV.fetch('APP_ENV', 'development').to_sym)

loader = Zeitwerk::Loader.for_gem
loader.enable_reloading
loader.setup

# Robot app to move your robot on a table
module Robot
  VERSION = '0.0.1'
  extend Dry::Configurable

  setting :table_width, default: 5
  setting :table_height, default: 5
end
