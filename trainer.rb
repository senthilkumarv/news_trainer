require 'rubygems'
require 'sinatra'
require 'models'
require 'json'

get '/' do
  content_type :json
  { :news_items => Item.all }.to_json
end

post '/update_category' do
  body = request.body.read
  print body
  data = JSON.parse body
  news_item = Item.get data['id']

  if news_item == nil then
    status 404
    return
  end

  categories = data['categories']

  categories.each { |category_name|
    category = ItemCategory.new
    category.item = news_item
    category.category = category_name
    category.save
  }
  status 200
end
