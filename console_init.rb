$LOAD_PATH << '.'

require 'rubygems'
require 'bundler/setup'
require 'rake'
require 'mongoid'

environment = ENV['RAKE_ENV'] || :development

Dir["#{::File.dirname(__FILE__)}/domain/model/*.rb"].each {|file| require file }


# load mongo
Mongoid.load!(::File.dirname(__FILE__) + "/config/mongoid.yml", environment)