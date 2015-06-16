require_relative 'database_connector.rb'

class Rating
  include DatabaseConnector
  
  # rating - String of the movie rating (G, PG, PG-13, R, etc)
  attr_reader :rating, :id

  
  def initialize(args)
    @id = args["id"] || ""
    @rating = args[:rating] || args["rating"]
  end
  
  def to_s
    "id: #{id}\t\tname: #{rating}"
  end
  
  
end