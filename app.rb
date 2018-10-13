require 'sinatra/base'
require './lib/datacontroller.rb'

class Datamanager < Sinatra::Base
  enable :sessions

  get '/' do
    erb(:index)
  end

  get '/all' do
    @data_sets = Datacontroller.get_all
    erb(:all)
  end

  get '/search' do
    @data_sets = Datacontroller.search(params['product'], params['customer'], params['measure'])
    erb(:search)
  end

  run! if app_file == $PROGRAM_NAME
end
