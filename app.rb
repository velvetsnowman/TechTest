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

  get '/results' do
    session[:product] = params['product']
    session[:customer] = params['customer']
    session[:measure] = params['measure']
    @data_sets = Datacontroller.search(params['product'], params['customer'], params['measure'])
    erb(:results)
  end

  get '/updated_results' do
    Datacontroller.check_searched_errors
    @data_sets = Datacontroller.search(session[:product], session[:customer], session[:measure])
    erb(:updated_results)
  end

  get '/all_results' do
    Datacontroller.check_all_errors
    redirect '/all'
  end

  run! if app_file == $PROGRAM_NAME
end
