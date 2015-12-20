module Bijou
  class Request
    attr_reader :vars

    def initialize(env)
      @vars = Rack::Request.new(env)
    end
  end
end
