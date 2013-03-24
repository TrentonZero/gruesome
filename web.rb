require 'sinatra'
require 'mongo' 
require 'uri'

get '/' do
  puts "<p>Hello, world. This is KJW.</p>"
  puts "<form name=\"input\" action=\"/\" method=\"post\">"
  puts "<input type=\"submit\" value=\"Submit\">"
  puts "</form>"
end

post '/' do
  db = get_connection
  
  puts "Collections"
  puts "==========="
  collections = db.collection_names
  puts collections
end

def get_connection
  return @dbconnection if @db_connection
  
  db = URI.parse(ENV['MONGOHQ_URL'])
  db_name = db.path.gsub(/^\//,'')
  @db_connection = Mongo::Connection.new(db.host, db.port).db(db_name)
  @db_connection.authenticate(db.user, db.password) unless (db.user.nil? || db.user.nil?)
  @db_connection
  
end
