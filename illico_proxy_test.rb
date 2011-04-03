begin 
  require_relative 'illico_proxy.rb' #>=1.9
rescue NameError
  require File.expand_path('../illico_proxy.rb', __FILE__)
end

#before:   sudo gem install test-unit   sudo gem install rack-test
require 'test/unit'
require 'rack/test'

class IllicoProxyTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end
  
  def test_should_not_be_valid_url
    get '/load?code=fhfjgk785'
    assert_equal '400', last_response.body
  end
  
  def test_should_not_find_file
    get '/load?code=fhfjgk785&key=7679hg89'
    assert_equal '204', last_response.body
  end
  
  def test_should_save
    post '/save?code=test&key=test', :doc => "Bla bla"
    assert_equal '200', last_response.body
  end
  
  def test_should_accept_json
    post '/save?code=test&key=test', :doc => "Ble ble", :content_type => :json, :accept => :json
    assert_equal '200', last_response.body
    
    get '/load?code=test&key=test'
    assert_equal 'Ble ble', last_response.body
  end
  
  def test_should_save_then_load_then_save_then_load
    post '/save?code=test&key=test', :doc => "Bla bla"
    assert_equal '200', last_response.body
    
    get '/load?code=test&key=test'
    assert_equal 'Bla bla', last_response.body
    
    post '/save?code=test&key=test', :doc => "Bla bla bla"
    assert_equal '200', last_response.body
    
    get '/load?code=test&key=test'
    assert_equal 'Bla bla bla', last_response.body
  end
end



