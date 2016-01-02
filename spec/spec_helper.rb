require "simplecov"
SimpleCov.start
$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "bijou"

SimpleCov.start do
  formatter SimpleCov::Formatter::MultiFormatter[SimpleCov::Formatter::HTMLFormatter]
end
