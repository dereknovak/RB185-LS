require 'sinatra'
require 'sinatra/content_for'
require 'tilt/erubis'

require_relative 'database_persistence'

configure do
  enable :sessions
  set :session_secret, SecureRandom.hex(32)
end

configure(:development) do
  require 'sinatra/reloader'
  also_reload 'database_persistence.rb'
end

before do
  @storage = DatabasePersistence.new(logger)
end

get '/' do
  redirect '/home'
end

get '/home' do
  erb :home
end

get '/customers/lookup' do
  erb :customer_lookup
end

get '/workorders' do
  'Workorders to come...'
end

get '/pricing' do
  'Pricing to come...'
end

post '/customers/lookup'



