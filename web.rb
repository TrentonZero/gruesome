require 'sinatra'
require 'mongo' 
require 'uri'

get '/' do
  response =  "<p>Hello, world. This is KJW.</p>"
  response += "<form name=\"input\" action=\"/\" method=\"post\">"
  response += "<input type=\"submit\" value=\"Submit\">"
  response += "</form>"
  response
end

post '/' do
  db = get_connection
  
  response = ""
  output_collection = db.collection('gameOutput')

  output_collection.find().each { |doc| 
    response += doc
  }
 
  response
  
end

def get_connection
  return @dbconnection if @db_connection
  
  db = URI.parse(ENV['MONGOHQ_URL'])
  db_name = db.path.gsub(/^\//,'')
  @db_connection = Mongo::Connection.new(db.host, db.port).db(db_name)
  @db_connection.authenticate(db.user, db.password) unless (db.user.nil? || db.user.nil?)
  @db_connection
  
end
