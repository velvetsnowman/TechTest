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
    erb(:search)
  end

  get '/search_results' do
    @data_sets = Datacontroller.search(params['product'], params['customer'], params['measure'])
    erb(:search_results)
  end

  get '/updated_results' do
    Datacontroller.check_errors
    erb(:updated_results)
  end

  run! if app_file == $PROGRAM_NAME
end
