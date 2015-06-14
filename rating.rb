require_relative 'database_connector.rb'

class Rating
  include DatabaseConnector
    
  attr_reader :rating

  
  def initialize(args)
    @id = ""
    @rating = args[:rating]
  end
  
  
  
  
end