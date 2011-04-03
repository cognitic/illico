#before:   sudo gem install rest-client
require 'rubygems'
require'sinatra'
require'rest-client'

post '/save' do
  answer = RestClient.post "http://memento.cognitic.com/save?code=#{params[:code]}&key=#{params[:key]}", :doc => params[:doc]
  return answer.body
end

get'/load' do
  answer = RestClient.get "http://memento.cognitic.com/load?code=#{params[:code]}&key=#{params[:key]}"
  return answer.body
end