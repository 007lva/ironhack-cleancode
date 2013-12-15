$LOAD_PATH << '.'

require 'sinatra'
require 'app/admin'
require 'app/api'
require 'mongoid'
Mongoid.load!(::File.dirname(__FILE__) + "/config/mongoid.yml")

map '/admin' do
  run Admin
end

map '/api' do
  run Api
end