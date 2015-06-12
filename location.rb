require_relative 'database_connector.rb'

 CONNECTION=SQLite3::Database.new("movies.db")
 CONNECTION.results_as_hash = true

class Location
  include DatabaseConnector

  attr_reader :name, :num_seats, :num_staff

  
  def initialize(args)
    @id = ""
    @name = args[:name]
    @num_seats = args[:num_seats]
    @num_staff = args[:num_staff]
  end
  
  
  
  
end