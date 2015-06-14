require_relative 'database_connector.rb'

 CONNECTION=SQLite3::Database.new("movies.db")
 CONNECTION.results_as_hash = true

class Rating
  include DatabaseConnector
    
  attr_reader :rating

  
  def initialize(args)
    @id = ""
    @rating = args[:rating]
  end
  
  
  
  
end