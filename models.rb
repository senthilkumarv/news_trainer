require 'rubygems'
require 'sinatra'
require 'data_mapper'
require 'dm-core'
require 'dm-validations'
require 'logger'

configure :development do
  DataMapper.setup(:default, {
    :adapter  => 'mysql',
    :host     => '127.0.0.1',
    :username => 'booster_tester' ,
    :password => '12345678',
    :database => 'booster_test'})  
  DataMapper::Logger.new(STDOUT, :debug)
end

configure :test do
  DataMapper.setup(:default, {
    :adapter  => 'mysql',
    :host     => '127.0.0.1',
    :username => 'booster_tester' ,
    :password => '12345678',
    :database => 'booster_test'})  
  DataMapper::Logger.new(STDOUT, :debug)
end

configure :production do
  DataMapper.setup(:default, {
    :adapter  => 'mysql',
    :host     => '127.0.0.1',
    :username => 'booster_app_user' ,
    :password => 'B00$t3rU$3r',
    :database => 'booster'})  
  DataMapper::Logger.new(STDOUT, :debug)
end

class Item
  include DataMapper::Resource
  property :title, String
  property :transformed_text, Text
  property :item_digest, String, :key => true
  has n, :item_categories
end

class ItemCategory
  include DataMapper::Resource
  property :id, Serial
  property :category, String
  belongs_to :item
end

DataMapper.auto_upgrade!
