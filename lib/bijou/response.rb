module Bijou
  class Response
    attr_reader :reply

    def initialize(body, status, headers = {})
      @reply = Rack::Response.new body, status, headers
    end
  end
end
