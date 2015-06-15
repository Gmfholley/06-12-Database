require_relative 'database_connector.rb'

CONNECTION=SQLite3::Database.new("movies.db")
CONNECTION.results_as_hash = true
CONNECTION.execute("PRAGMA foreign_keys = ON;")

class LocationTimeSlot
  include DatabaseConnector

  attr_reader :location_id, :timeslot_id, :movie_id, :num_tickets_sold

  # initializes object
  #
  # args -      Options Hash
  #             id                - Integer of the ID number of record in the database
  #             location_id       - Integer of the location_id in the locations table
  #             timeslot_id       - Integer of the timeslot_id in timeslots table
  #             movie_id          - Integer of the movie_id in movies table
  #             num_tickets_sold  - Integer of the number of tickets sold for this time slot
  #
  def initialize(args)
    @location_id = args[:location_id] || args["location_id"]
    @timeslot_id = args[:timeslot_id] || args["timeslot_id"]
    @movie_id = args[:movie_id] || args["movie_id"]
    @num_tickets_sold = args["num_tickets_sold"] || 0
  end
  
  # returns the String representation of the time slot
  #
  # returns String
  def to_s
    "location:\t#{location}\t\ttimeslot:\t#{timeslot}\t\tmovie:\t#{movie}"
  end
  
  # returns the movie's name
  #
  # returns String
  def movie
    m = Movie.create_from_database(movie_id)
    m.name
  end
  
  # returns the time slot in time
  #
  # returns Integer
  def timeslot
    t = TimeSlot.create_from_database(timeslot_id)
    t.time_slot
  end
  
  # returns the location name for this time slot
  #
  # returns String
  def location
    l = Location.create_from_database(location_id)
    l.name
  end

  # returns an Array of hashes of all movies at this location
  #
  # returns an Array
  def all_at_this_location
    LocationTimeSlot.as_objects(LocationTimeSlot.all_that_match("location_id", @location_id, "=="))
  end
  
  def all_at_this_time
    LocationTimeSlot.as_objects(LocationTimeSlot.all_that_match("timeslot_id", @timeslot_id, "=="))
  end
  
  def all_of_this_movie
    LocationTimeSlot.as_objects(LocationTimeSlot.all_that_match("movie_id", @movie_id, "=="))
  end
  
  def self.delete_record(location_id, timeslot_id)
    CONNECTION.execute("DELETE FROM #{self.to_s.pluralize} WHERE location_id == #{location_id} AND timeslot_id == #{timeslot_id}")
  end
  
  def self.all_with_tickets_greater_than(num_tickets)
    LocationTimeSlots.as_objects(LocationTimeSlot.all_that_match("num_tickets_sold", num_tickets, ">"))
  end
  
  def self.create_from_database(location_id, timeslot_id)
    rec = CONNECTION.execute("SELECT * FROM #{self.to_s.pluralize} WHERE location_id = #{location_id} AND timeslot_id = #{timeslot_id};")
    self.new(rec[0])
  end
  
end