module Bijou
  class Route
    attr_reader :controller
    attr_reader :action

    def initialize(route_arr)
      @controller = route_arr.last[:controller].to_camel_case << "Controller"
      @action = route_arr.last[:action]
    end

    def setup_controller
      Object.const_get(controller)
    end
  end
end
