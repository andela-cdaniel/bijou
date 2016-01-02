require "simplecov"

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "bijou"

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter
]
SimpleCov.start
