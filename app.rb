require 'sinatra/base'
require './lib/datacontroller.rb'

class Datamanager < Sinatra::Base
  enable :sessions
  register Sinatra::Flash

  get '/' do

  end

  run! if app_file == $PROGRAM_NAME
end
