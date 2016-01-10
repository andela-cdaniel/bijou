module Bijou
  class Router
    def initialize
      @app_routes = Hash.new { |hash, key| hash[key] = [] }
    end

    def draw &block
      instance_eval &block
    end

    def root(action)
      get "/", action
    end

    %w(get post put delete).each do |method_name|
      define_method method_name do |path, action|
        path = path[0] == "/" ? path : "/" << path
        action = action.class == Hash ? action[:to] : action
        @app_routes[method_name.to_sym] << [path, parse_action(action)]
      end
    end

    def handle_request(req)
      pattern = /\A(\/[a-z]+)(\/[0-9]+)(\/[a-z]+)?((\/[0-9]+)(\/[a-z]*){1,})*\z/
      path = req.path_info
      http_verb = req.request_method.downcase.to_sym

      if path.match pattern
        route_arr = @app_routes[http_verb].find { |item| generate_regex(path) =~ item.first }

        if route_arr
          params_key = (route_arr.first.match /\:[a-z]+/).to_s.gsub(":", "").to_sym
          params_val = (path.match /\/[\d]+/).to_s.gsub("/", "")
          req.params[params_key] = params_val
          Route.new(route_arr)
        end
      else
        route_arr = @app_routes[http_verb].find { |item| path == item.first }
        Route.new(route_arr) if route_arr
      end
    end

    private

    def parse_action(str)
      {controller: $1, action: $2} if str.match /\A([a-z]+)#([a-z]+)\z/
    end

    def generate_regex(path)
      regex = path.gsub(/\d{2,}/, "1").split("").map do |char|
        char = char.to_i > 0 ? ":[a-z]+" : char
      end
      Regexp.new(regex.join)
    end
  end
end
