PATH = __dir__

require File.join(PATH, "config", "setup")
require File.join(PATH, "config", "routes")

use Rack::MethodOverride
use Rack::Reloader

run BijouApp
