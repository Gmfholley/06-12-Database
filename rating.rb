require_relative 'database_connector.rb'

class Rating
  include DatabaseConnector
  
  # rating - String of the movie rating (G, PG, PG-13, R, etc)
  attr_reader :id
  attr_accessor :rating
  
  def initialize(args={})
    @id = args["id"] || ""
    @rating = args[:rating] || args["rating"]
    @errors = []
  end
  
  def to_s
    "id: #{id}\t\tname: #{rating}"
  end
  
  
  # returns Boolean if ok to delete
  #
  # id - Integer of the id to delete
  #
  # returns Boolean
  def self.ok_to_delete?(id)
    if Movie.where_match("rating_id", id, "==").length > 0
        false
    else
        true
    end
  end
  
  # returns Boolean if data is valid
  #
  # returns Boolean
  def valid?
    @errors = []
    # check thename exists and is not empty
    if rating.empty?
      @errors << {message: "Name cannot be empty.", variable: "rating"}
    end
    
    @errors.empty?
  end
  
end