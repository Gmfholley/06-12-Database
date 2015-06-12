require_relative 'database_connector.rb'

 CONNECTION=SQLite3::Database.new("movies.db")
 CONNECTION.results_as_hash = true

class Studio
  include DatabaseConnector
    
  attr_reader :name

  
  def initialize(args)
    @id = ""
    @name = args[:name]
  end
  
  
  
  
end