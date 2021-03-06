require 'rubygems'
require 'sinatra'
require 'models'
require 'json'

set :public_folder, File.dirname(__FILE__) + '/static'

get '/' do
  content_type :json
  { :news_items => Item.all(:item_categories => nil, :limit => 5) }.to_json
end

post '/update_category' do
  begin
  body = request.body.read
  data = JSON.parse body
  data.each { |item|
    news_item = Item.get item['id']

    if news_item == nil then
      status 404
      next
    end

    categories = item['categories']

    categories.each { |category_name|
      category = ItemCategory.new
      category.item = news_item
      category.category = category_name
      category.save
    }
  }
  status 200 if status != 404
  rescue
    status 500
  end
end
