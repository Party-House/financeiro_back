require 'sinatra'
require 'sinatra/cross_origin'
require_relative 'constants'

configure do
  enable :cross_origin
end

options "*" do
  response.headers["Allow"] = "HEAD,GET,PUT,POST,DELETE,OPTIONS"
  response.headers["Access-Control-Allow-Headers"] = "X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept"
  200
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
  response.headers["Access-Control-Allow-Origin"] = "*"
  response.body = data.to_json
  response
end

post '/transfer' do
  response.status = 201
  response.headers["Access-Control-Allow-Origin"] = "*"
  response.body = "Success"
  response
end
