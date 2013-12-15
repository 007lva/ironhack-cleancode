$LOAD_PATH << '.'

require 'sinatra'
require 'app/app'

map '/' do
  run App
end