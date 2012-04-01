require 'rubygems'
require 'trainer'
require 'rack/test'

ENV['RACK_ENV'] = 'test'

describe "when I hit the home page" do
  
  include Rack::Test::Methods
  
  def app
    Sinatra::Application
  end

  it "should open the homepage" do
    get '/'
    last_response.should be_ok
  end

  it "should render json" do
    get '/'
    last_response.content_type.should == 'application/json;charset=utf-8'
  end

  it "should have news_items as the parent object and it should not be null" do
    get '/'
    result = JSON.parse last_response.body
    result.has_key?('news_items').should be_true
    result['news_items'].should_not be_nil
  end

  it "should return 200 when the key is found and update is successful" do
    post '/update_category/01b5d23af66b81c5f40963e901013e0a'
    last_response.status.should == 200
  end

  it "should return 404 when the key is not found" do
    post '/update_category/21a7a378511fdc7c1ac4dd3fbc3259b6'
    last_response.status.should == 404
  end
  
  it "should return 500 when the key is found and update fails" do
    post '/update_category/21a7a378511fdc7c1ac4dd3fbc3259b6'
    last_response.status.should == 500
  end
end
