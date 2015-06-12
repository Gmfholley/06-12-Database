require_relative 'database_connector.rb'

class Movie
  include DatabaseConnector
  
  attr_reader :name, :description, :rating_id, :studio_id, :length, :location_id
  
  CONNECTION=SQLite3::Database.new("movies.db")
  CONNECTION.results_as_hash = true
  
  def initialize(args)
    @id = ""
    @name = args[:name]
    @description = args[:description]
    @rating_id = args[:rating_id]
    @studio_id = args[:studio_id]
    @length = args[:length]
    @location_id = args[:location_id]
  end
  
  
  
  
end