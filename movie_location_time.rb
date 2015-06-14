require_relative 'database_connector.rb'

CONNECTION=SQLite3::Database.new("movies.db")
CONNECTION.results_as_hash = true
CONNECTION.execute("PRAGMA foreign_keys = ON;")

class MovieLocationTimeSlot
  include DatabaseConnector

  attr_reader :movie_id, :location_id, :timeslot_id, :num_tickets_sold

  
  def initialize(args)
    @id = ""
    @movie_id = args[:movie_id]
    @location_id = args[:location_id]
    @timeslot_id = args[:timeslot_id]
    @num_tickets_sold = 0
  end

end