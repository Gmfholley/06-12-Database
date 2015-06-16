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
    LocationTime.where_match("timeslot_id", id, "==")
  end
  
  def to_s
    "id: #{id}\t\ttime slot: #{time_slot}"
  end
  
  # returns the total staff needed for a particular time slot
  #
  # returns an Integer
  def num_staff_needed
    sum = 0
    staff_array = CONNECTION.execute("SELECT SUM(locations.num_staff) FROM locationtimes INNER JOIN times ON locationtimes.timeslot_id = times.id INNER JOIN locations ON locationtimes.location_id = locations.id WHERE times.id = #{id} GROUP BY locationtimes.location_id;")
    staff_array.each do |hash|
      sum += hash["SUM(locations.num_staff)"]
    end
    sum
  end
  
end