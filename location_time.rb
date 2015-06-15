require_relative 'database_connector.rb'

# CONNECTION=SQLite3::Database.new("movies.db")
# CONNECTION.results_as_hash = true
# CONNECTION.execute("PRAGMA foreign_keys = ON;")

class LocationTime
  include DatabaseConnector
  alias_method :save, :save_record 
  
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
    t = Time.create_from_database(timeslot_id)
    t.time_slot
  end
  
  # returns the location name for this time slot
  #
  # returns String
  def location
    l = Location.create_from_database(location_id)
    l.name
  end
  
  # returns whether tickets are sold out for the location
  #
  # returns Boolean
  def sold_out?
    l = Location.create_from_database(location_id)
    l.num_seats == num_tickets_sold
  end
  
  # returns how many tickets remain at this location
  #
  # returns Integer
  def tickets_remaining
    l = Location.create_from_database(location_id)
    l.num_seats - num_tickets_sold
  end
  
  # returns an Array of objects of all movies at this location
  #
  # returns an Array
  def where_this_location
    LocationTime.where_match("location_id", @location_id, "==")
  end

  # saves record with Module's reord if condition met
  # overwrites Modules save_record method
  #
  # returns Boolean
  def save_record
    if location.has_available_time_slot?
      save
      true
    else
      false
    end
  end
  
  # returns an Array of objects of all movies at this location
  #
  # returns an Array
  def where_this_time
    LocationTime.where_match("timeslot_id", @timeslot_id, "==")
  end
  
  # returns an Array of objects of all movies at this location
  #
  # returns an Array
  def where_this_movie
    LocationTime.where_match("movie_id", @movie_id, "==")
  end
  
  # returns all Locations with tickets greater than the number of tickets
  #
  # num_tickets    - Integer of the number of tickets sold
  #
  # returns an Array of LocationTime objects
  def self.where_tickets_greater_than(num_tickets)
    LocationTime.where_match("num_tickets_sold", num_tickets, ">")
  end
  
  
  def self.where_sold_out(sold_out=true)
    if sold_out
     LocationTime.as_objects(CONNECTION.execute("SELECT * FROM locationtimes locationtime LEFT OUTER JOIN locations location ON location.id = locationtime.location_id WHERE location.num_seats <= locationtime.num_tickets_sold;"))
   else
     LocationTime.as_objects(CONNECTION.execute("SELECT * FROM locationtimes locationtime LEFT OUTER JOIN locations location ON location.id = locationtime.location_id WHERE location.num_seats > locationtime.num_tickets_sold;"))
   end
  end
  
  # overwrites DatabaseConnector Module method because this Class has a composite key
  #
  # location_id     - Integer of the location_id part of the composite key
  # timeslot_id     - Integer of the timeslot_id part of the composite key
  #
  # returns nothing
  def self.delete_record(location_id, timeslot_id)
    CONNECTION.execute("DELETE FROM #{self.to_s.pluralize} WHERE location_id == #{location_id} AND timeslot_id == #{timeslot_id}")
  end
  
  # overwrites DatabaseConnector Module method because this Class has a composite key
  #
  # location_id     - Integer of the location_id part of the composite key
  # timeslot_id     - Integer of the timeslot_id part of the composite key
  #
  # returns object with this location_id/timeslot_id
  def self.create_from_database(location_id, timeslot_id)
    rec = CONNECTION.execute("SELECT * FROM #{self.to_s.pluralize} WHERE location_id = #{location_id} AND timeslot_id = #{timeslot_id};")
    self.new(rec[0])
  end
  
end