require 'sinatra'
require 'sinatra/cross_origin'
require_relative 'constants'

configure do
  enable :cross_origin
end

get '/' do
  "Hello, World!"
end

get '/users' do
  data = [
    {:id => 1, :name=>"Andre"},
    {:id => 2, :name=>"Dylan"},
    {:id => 3, :name=>"Guilherme"},
    {:id => 4, :name=>"Murilo"},
    {:id => 5, :name=>"Soler"}
  ]
  response.body = data.to_json
end

post '/transfer' do
  response.status = 201
  response.body = "Success"
  response
end
