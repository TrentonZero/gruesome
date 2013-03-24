require 'sinatra'
require 'mongo' 
require 'uri'

$log = ""

get '/' do
  response =  "<p>Welcome to herokuGruesome.</p>"
  response += "<form name=\"input\" action=\"/\" method=\"post\">"
  response += "Game Key: <input type=\"text\" name=\"gamekey\">"
  response += "<input type=\"submit\" value=\"Submit\">"
  response += "</form>"
  response
end

post '/' do
  db = get_connection
  
  key = request.POST["gamekey"]
  
  response = "<p>"
  output_collection = db.collection('gameOutput')

  output_collection.find("gamekey" => key).sort([["sequence", :asc]]).each { |doc| 
    response += doc["line"]
  }
  
  output_collection.remove()
  
  response = response.gsub("\n", "<br \>\n")
  response = response.gsub(" ", "&nbsp;")
  response += "</p>\n"

  $log += response 
   
  $log
  
end

def get_connection
  return @dbconnection if @db_connection
  
  db = URI.parse(ENV['MONGOHQ_URL'])
  db_name = db.path.gsub(/^\//,'')
  @db_connection = Mongo::Connection.new(db.host, db.port).db(db_name)
  @db_connection.authenticate(db.user, db.password) unless (db.user.nil? || db.user.nil?)
  @db_connection
  
end
