require 'sinatra'
require 'sinatra/activerecord'
require './config/environments' #database configuration

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
  return_message[:status] = "success"
  return_message[:code] = 200
  return_message.to_json
end