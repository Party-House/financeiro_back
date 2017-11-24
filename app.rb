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
  purc_service.add_purchase jdata
  return_message[:message] = "success"
  return_message[:status] = 200
  return_message.to_json
end