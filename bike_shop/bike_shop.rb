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

helpers do
  def generate_tax(num)
    (num * 0.0825).round(2)
  end

  def format_money(amount)
    format('%.2f', amount)
  end
end

before do
  @storage = DatabasePersistence.new(logger)
end

get '/' do
  redirect '/home'
end

get '/home' do
  @tab = 'Home'
  erb :home
end

get '/customers/lookup' do
  @tab = 'Customer Lookup'
  erb :customer_lookup
end

get '/workorders' do
  @tab = 'Work Orders'
  @workorders = @storage.load_workorders
  erb :workorders
end

get '/pricing' do
  @tab = 'Pricing'
  @services = @storage.load_pricing
  erb :pricing
end

get '/customers/new' do
  @tab = 'New Customer'
  erb :customer_new
end

get '/customers/:customer_id' do
  @tab = 'Customer Profile'
  @customer = @storage.load_customer_info(params[:customer_id], 'customer')
  @bicycles = @storage.load_customer_bicycles(@customer['id'])
  @workorders = @storage.load_customer_workorders(@customer['id'])
  erb :customer_profile
end

get '/customers/:customer_id/bicycles/add' do
  @tab = 'New Bicycle'
  erb :bicycle_new
end

get '/workorders/:workorder_number' do
  @customer = @storage.load_customer_info(params[:workorder_number], 'workorder')
  @bicycle = @storage.load_bicycle_info(params[:workorder_number])
  @workorder = @storage.load_workorder_info(params[:workorder_number])
  @tab = "Work Order #{@workorder['id']}"
  @services = @storage.load_services(params[:workorder_number])
  @sum = @storage.service_total(@workorder['id']).to_i
  @tax = generate_tax(@sum)

  erb :workorder
end

post '/customers/lookup' do
  @tab = 'Lookup Results'
  @customers = @storage.find_customers(params)
  erb :customer_results
end

post '/customers/new' do
  unique_customer = @storage.add_customer(params)

  if unique_customer
    customer = @storage.find_customer(params).first
    redirect "/customers/#{customer['id']}"
  else
    session[:message] = 'Customer is already in database.'
    redirect 'customers/new'
  end
end

post '/customers/:customer_id/bicycles/add' do
  @storage.add_bicycle(params)
  redirect "/customers/#{params['customer_id']}"
end

post '/workorders/new/:bicycle_id' do
  @storage.add_workorder(params[:bicycle_id])
  workorder_number = @storage.load_last_workorder

  redirect "workorders/#{workorder_number}"
end

post '/workorders/:workorder_number/services/add' do
  service = @storage.add_service(params)
  session[:message] = 'Must select service before adding.' unless service
  redirect "/workorders/#{params[:workorder_number]}"
end

post '/workorders/:workorder_number/complete' do
  @storage.complete_workorder(params[:workorder_number])
  session[:message] = 'Work Order completed!'
  redirect "/workorders/#{params[:workorder_number]}"
end



