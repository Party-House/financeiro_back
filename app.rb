require 'sinatra'
require 'sinatra/cross_origin'
require 'sinatra/activerecord'
require './config/environments' #database configuration
require './services/purchase_service'
require './services/transfer_service'
require './services/user_service'
require_relative 'constants'

configure do
  enable :cross_origin
end

options "*" do
  response.headers["Allow"] = "HEAD,GET,PUT,POST,DELETE,OPTIONS"
  response.headers["Access-Control-Allow-Headers"] = "X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept"
  200
end

transfer_service = TransferService.new
purc_service = PurchaseService.new
user_service = UserService.new

get '/' do
  "Hello, World!"
end

get '/users' do
  origin = request.env['HTTP_ORIGIN']
  if origin[CORS_ORIGIN]
    response.headers["Access-Control-Allow-Origin"] = origin[CORS_ORIGIN]
  end
  response.body = user_service.getUsers.to_json
  response
end

get '/bank-accounts' do
  origin = request.env['HTTP_ORIGIN']
  if origin[CORS_ORIGIN]
    response.headers["Access-Control-Allow-Origin"] = origin[CORS_ORIGIN]
  end
  response.body = user_service.getBankAccounts.to_json
  response
end

post '/add-purchase' do
  request.body.rewind
  jdata = JSON.parse(
    request.body.read,
    :symbolize_names => true
  )
  purc_service.addPurchase jdata
  origin = request.env['HTTP_ORIGIN']
  if origin[CORS_ORIGIN]
    response.headers["Access-Control-Allow-Origin"] = origin[CORS_ORIGIN]
  end
  response.body = "Success"
  response
end

get '/purchases-in/:month/:year' do
  origin = request.env['HTTP_ORIGIN']
  if origin[CORS_ORIGIN]
    response.headers["Access-Control-Allow-Origin"] = origin[CORS_ORIGIN]
  end
  response.body = purc_service.getPurchasesByMonth(
    params[:month], params[:year]).to_json
  response
end

get '/get-total-debt' do
  origin = request.env['HTTP_ORIGIN']
  if origin[CORS_ORIGIN]
    response.headers["Access-Control-Allow-Origin"] = origin[CORS_ORIGIN]
  end
  response.body = purc_service.getTotalDebt.to_json
  response
end

post '/add-transfer' do
  request.body.rewind
  jdata = JSON.parse(
    request.body.read,
    :symbolize_names => true
  )
  transfer_service.addTransfer jdata
  origin = request.env['HTTP_ORIGIN']
  if origin[CORS_ORIGIN]
    response.headers["Access-Control-Allow-Origin"] = origin[CORS_ORIGIN]
  end
  response.body = "Success"
  response
end