require "bijou/dependencies"
require "bijou/version"
require "bijou/request"
require "bijou/response"
require "bijou/route"
require "bijou/router"
require "bijou/bijou_record"
require "bijou/base_controller"

module Bijou
  class Application
    attr_reader :routes

    def initialize
      @routes = Router.new
    end

    def call(env)
      req = Request.new(env).vars
      return Respons.new("", 500, {}) if req.path_info == "/favicon/ico"
      res = routes.handle_request(req)

      if res.nil?
        return Response.new("Page not found", 404, { "content-type" => "text/html" }).reply
      end

      controller = res.setup_controller.new(req)
      controller.send(res.action)

      controller.show_response ? controller.show_response : controller.render(res.action)

    end
  end
end
