require_relative 'database_connector.rb'

# CONNECTION=SQLite3::Database.new("movies.db")
# CONNECTION.results_as_hash = true
# CONNECTION.execute("PRAGMA foreign_keys = ON;")

class Movie
  include DatabaseConnector
  
  attr_accessor :name, :description, :length, :id
  attr_reader :studio_id, :rating_id
  
  # initializes object
  #
  # args -      Options Hash
  #             id            - Integer of the ID number of record in the database
  #             description   - String of the name
  #             rating_id     - Integer of the rating_id in ratings table
  #             studio_id     - Integer of the studio_id in studios table
  #             length        - Integer of the length of the movie
  #
  def initialize(args)
    @id = args["id"] || ""
    @name = args[:name] || args["name"]
    @description = args[:description] || args["description"]
    @rating_id = args[:rating_id] || args["rating_id"]
    @studio_id = args[:studio_id] || args["studio_id"]
    @length = args[:length] || args["length"]
  end
  
  # returns String representing this object's parameters
  #
  # returns String
  def to_s
    "id:\t#{@id}\t\tname:\t#{name}\t\trating:\t#{rating}\t\tstudio:\t#{studio}\t\tlength:\t#{length}"
  end

  # returns the rating
  #
  # returns String
  def rating
    r = Rating.create_from_database(rating_id)
    r.rating
  end
  
  # returns the studio name
  #
  # returns String
  def studio
    s = Studio.create_from_database(studio_id)
    s.name
  end
  
  # returns Array of all the location-times for this movie
  #
  # returns Array
  def location_times
    times = where_this_id_in_another_table("locationtimeslots", "movie_id")
    LocationTimeSlot.as_objects(times)
  end
  
  
end