require_relative 'database_connector.rb'

class Time
  include DatabaseConnector

  attr_reader :time_slot, :id

  
  def initialize(args)
    @id = args["id"] || ""
    @time_slot = args[:time] || args["time"]
  end

  # returns Array of all the location-times for this movie
  #
  # returns Array
  def location_times
    LocationTime.as_objects(LocationTime.all_that_match("timeslot_id", id, "=="))
  end
end