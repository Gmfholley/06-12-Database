require_relative 'database_connector.rb'

 CONNECTION=SQLite3::Database.new("movies.db")
 CONNECTION.results_as_hash = true
 CONNECTION.execute("PRAGMA foreign_keys = ON;")

class Location
  include DatabaseConnector

  attr_reader :name, :num_seats, :num_staff, :num_time_slots

  
  def initialize(args)
    @id = ""
    @name = args[:name]
    @num_seats = args[:num_seats]
    @num_staff = args[:num_staff]
    @num_time_slots = args[:num_time_slots]
  end
  
  
  
  
end