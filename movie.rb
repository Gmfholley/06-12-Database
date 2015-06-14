require_relative 'database_connector.rb'

CONNECTION=SQLite3::Database.new("movies.db")
CONNECTION.results_as_hash = true
CONNECTION.execute("PRAGMA foreign_keys = ON;")

class Movie
  include DatabaseConnector
  
  attr_accessor :name, :description, :rating_id, :studio_id, :length

  
  def initialize(args)
    @id = ""
    @name = args[:name]
    @description = args[:description]
    @rating_id = args[:rating_id]
    @studio_id = args[:studio_id]
    @length = args[:length]
  end
  
  
  
  
end