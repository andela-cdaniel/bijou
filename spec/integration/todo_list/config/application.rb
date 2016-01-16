$LOAD_PATH << File.join(__dir__, "..", "app", "controllers")
$LOAD_PATH << File.join(__dir__, "..", "app", "models")

Dir["../app/models/*.rb"].each { |file| require file }

module MyAgenda
  class Application < Bijou::Application
  end
end
