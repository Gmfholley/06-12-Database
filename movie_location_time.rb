require_relative 'database_connector.rb'

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