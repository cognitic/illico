#before:   sudo gem install rest-client
require 'rubygems'
require'sinatra'
require'rest-client'

post '/save' do
  doc = params[:doc]
  if doc == nil then
    doc = request.body.read.to_s
  end
  answer = RestClient.post "http://illico.cognitic.com/save/memento.cognitic.com?code=#{params[:code]}&key=#{params[:key]}", :doc => doc
  return answer.body
end

get'/load' do
  answer = RestClient.get "http://illico.cognitic.com/load/memento.cognitic.com?code=#{params[:code]}&key=#{params[:key]}"
  return answer.body
end