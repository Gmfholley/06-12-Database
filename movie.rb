require_relative 'database_connector.rb'

class Movie
  include DatabaseConnector
  
  attr_accessor :name, :description, :length
  
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
    "id:\t#{@id}]\t\tname:\t#{name}\t\trating:\t#{rating}\t\tstudio:\t#{studio}\t\tlength:\t#{length}"
  end

  # returns the rating
  #
  # returns String
  def rating
    rating_hash = where_this_parameter_in_another_table("ratings", @rating_id, "id")
    rating_hash.first["rating"]
  end
  
  # returns the studio name
  #
  # returns String
  def studio
    studio_hash = where_this_parameter_in_another_table("studios", @studio_id, "id")
    studio_hash.first["name"]
  end
  
  # returns Array of all the location-times for this movie
  #
  # returns Array
  def location_times
    times = where_this_id_in_another_table("locationtimeslots", "movie_id")
    LocationTimeSlot.as_objects(times)
  end
  
  
end