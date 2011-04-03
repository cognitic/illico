require 'rubygems'
#require '/home/abene/.gems/gems/rack-1.2.1/lib/rack.rb'
require '/home/abene/.gems/gems/sinatra-1.2.0/lib/sinatra.rb'
require '/home/abene/.gems/gems/tilt-1.2.2/lib/tilt.rb'
require 'illico'

set :run, false
set :environment, :production

run Sinatra::Application
