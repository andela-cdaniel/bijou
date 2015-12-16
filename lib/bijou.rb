require "bijou/version"

module Bijou
  class Application
    def call(env)
      [200, {"content-type" => "text/html"}, ["Welcome to your new Bijou App"]]
    end
  end
end
