require 'sinatra'
require 'sinatra/activerecord'
require './config/environments' #database configuration
require './services/purchase_service'

purc_service = PurchaseService.new

get '/' do
  "Hello, World!"
end

post '/add-purchase' do
  return_message = {}
  request.body.rewind
  jdata = JSON.parse(
    request.body.read,
    :symbolize_names => true
  )
  purc_service.addPurchase jdata
  return_message[:message] = "Success"
  return_message[:status] = 200
  return_message.to_json
end

get '/purchases-in/:month/:year' do
  return_message = {}
  purc_service.getPurchasesByMonth(
    params[:month], params[:year]).to_json
end