require 'rubygems'
require'sinatra'
require 'digest/sha1'


configure do
  # class << Sinatra::Base
  #   def options(path, opts={}, &block)
  #     route 'OPTIONS', path, opts, &block
  #   end
  # end
  # Sinatra::Delegator.delegate :options
  set :secret, 'presto781'
end


get '/' do
  
  "<html><body style='font-family:Courier New,Courier,monospace;'><h3>Welcome to illico web service !</h3><ul>" + 
  "<li>GET from /load/yoursitename.com?code=docname&key=password</li>" + 
  "<li>POST (via proxy) to /save/yoursitename.com?code=docname&key=password (Using \"doc\" as parameter name)</li>" + 
  "</ul></body></html>"
  #"<li>GET a save (<4Ko URL length limit) to /save/yoursitename.com?code=docname&key=password&doc=content</li>" +
end


get'/load/*' do
  
  site = params[:splat][0]
  if is_valid_URL?(site,params[:key],params[:code]) then
    
    keydir = Digest::SHA1.hexdigest(settings.secret + params[:key])
    codedir = Digest::SHA1.hexdigest(settings.secret + params[:code])
    if is_valid_path?(site,keydir,codedir) then
      
      docpath = "data/#{site}/#{keydir}/#{codedir}/doc.txt"
      if File.exists?(docpath)
          return File.open(docpath)
      else
          return "204" #Error 204 => No Content
      end
      
    else
      return "204" #Error 204 => No Content
    end
    
  else
    return "400" #Error 400 => Bad Request
  end
end


# options '/save/*' do
#   response.headers["Access-Control-Allow-Origin"] = "*"
#   response.headers["Access-Control-Allow-Methods"] = "GET, POST, OPTIONS"
#   response.headers["Access-Control-Allow-Headers"] = "Content-Type"
#   halt 200
# end


post '/save/*' do
  
  site = params[:splat][0]
  if is_valid_URL?(site,params[:key],params[:code]) then
    
    keydir = Digest::SHA1.hexdigest(settings.secret + params[:key])
    codedir = Digest::SHA1.hexdigest(settings.secret + params[:code])
    begin
      
      build_path(site,keydir,codedir) unless is_valid_path?(site,keydir,codedir)
      File.open("data/#{site}/#{keydir}/#{codedir}/doc.txt", 'w') do |f|
        f.write params[:doc]
      end
      return "200" #No Error 200 => Success
      
    rescue Exception=>e
        #return e.message
        return "409" #Error 400 => Conflict occured
    end
    
  else
      return "400" #Error 400 => Bad Request
  end
end


def is_valid_URL?(site,key,code)
  not ((site.to_s == "") or (key.to_s == "") or (code.to_s == "")) 
end  

def is_valid_path?(site,key,code)
  File.directory?("data/#{site}/") and File.directory?("data/#{site}/#{key}/") and File.directory?("data/#{site}/#{key}/#{code}/")
end

def build_path(site,key,code)
  directory = "data/#{site}/"
  Dir.mkdir(directory) unless File.directory?(directory)
  directory = "data/#{site}/#{key}/"
  Dir.mkdir(directory) unless File.directory?(directory)
  directory = "data/#{site}/#{key}/#{code}/"
  Dir.mkdir(directory) unless File.directory?(directory)
end



