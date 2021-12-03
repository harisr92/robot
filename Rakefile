# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('./lib', __dir__)

# rake spec
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'robot'

RSpec::Core::RakeTask.new(:spec) { |t| t.verbose = false }
RuboCop::RakeTask.new

task default: %i[spec rubocop]
