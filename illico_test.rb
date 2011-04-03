begin 
  require_relative 'illico.rb' #>=1.9
rescue NameError
  require File.expand_path('../illico.rb', __FILE__)
end

#before:   sudo gem install test-unit   sudo gem install rack-test
require 'test/unit'
require 'rack/test'

class IllicoTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end
  
  def test_should_access_root
    get '/'
    #puts last_response.status
    assert last_response.ok?
  end
  
  def test_should_not_be_valid_url
    get '/load/www.test.com?code=fhfjgk785'
    assert_equal '400', last_response.body
  end
  
  def test_should_not_find_file
    get '/load/www.test.com?code=fhfjgk785&key=7679hg89'
    assert_equal '204', last_response.body
  end
  
  def test_should_save
    post '/save/www.test.com?code=test&key=test', :doc => "Bla bla"
    assert_equal '200', last_response.body
  end
  
  def test_should_save_then_load_then_save_then_load
    post '/save/www.test.com?code=test&key=test', :doc => "Bla bla"
    assert_equal '200', last_response.body
    
    get '/load/www.test.com?code=test&key=test'
    assert_equal 'Bla bla', last_response.body
    
    post '/save/www.test.com?code=test&key=test', :doc => "Bla bla bla"
    assert_equal '200', last_response.body
    
    get '/load/www.test.com?code=test&key=test'
    assert_equal 'Bla bla bla', last_response.body
  end
end



