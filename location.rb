require_relative 'database_connector.rb'

class Location
  include DatabaseConnector

  attr_reader :name, :num_seats, :num_staff, :num_time_slots, :id

  # initializes object
  #
  # args -      Options Hash
  #             id                - Integer of the ID number of record in the database
  #             name              - String of the name of the room
  #             num_seats         - Integer of the number of seats
  #             num_staff         - Integer of the number of staff who have to work this theatre
  #             num_time_slots    - Integer of the number of time slots that this theatre can have a movie play
  #
  def initialize(args)
    @id = args["id"] || ""
    @name = args[:name] || args["name"]
    @num_seats = args[:num_seats] || args["num_seats"]
    @num_staff = args[:num_staff] || args["num_staff"]
    @num_time_slots = args[:num_time_slots] || args["num_time_slots"]
  end

  def to_s
    "id: #{id}\tname: #{name}\tnumber of seats: #{num_seats}\tnumber of staff: #{num_staff}\tnumber of movies played a day: #{num_time_slots}"
  end
  
  def has_available_time_slot?
    self.all_time_slots.length < num_time_slots
  end
  
  def all_time_slots
    LocationTime.where_match("location_id", id, "==")
  end
  
  # returns Array of all the location-times for this movie
  #
  # returns Array
  def location_times
    LocationTime.where_match("location_id", id, "==")
  end
  
end