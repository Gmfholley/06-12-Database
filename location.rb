require_relative 'database_connector.rb'

class Location
  include DatabaseConnector
  
  attr_reader :id
  attr_accessor :name, :num_seats, :num_staff, :num_time_slots, :errors

  # initializes object
  #
  # args -      Options Hash
  #             id                - Integer of the ID number of record in the database
  #             name              - String of the name of the room
  #             num_seats         - Integer of the number of seats
  #             num_staff         - Integer of the number of staff who have to work this theatre
  #             num_time_slots    - Integer of the number of time slots that this theatre can have a movie play
  #
  def initialize(args={})
    @id = args["id"] || ""
    @name = args[:name] || args["name"]
    @num_seats = args[:num_seats] || args["num_seats"]
    @num_staff = args[:num_staff] || args["num_staff"]
    @num_time_slots = args[:num_time_slots] || args["num_time_slots"]
    @errors = []
  end

  def to_s
    "id: #{id}\tname: #{name}\tnumber of seats: #{num_seats}\tnumber of staff: #{num_staff}\tnumber of movies played a day: #{num_time_slots}"
  end
  
  def max_num_time_slots
    CONNECTION.execute("SELECT COUNT(*) FROM times;").first[0]
  end  
       
  # returns a Boolean if this location has available time slots
  #    
  # returns Boolean
  def has_available_time_slot?
    self.all_time_slots.length < num_time_slots
  end
  
  # returns an Array of LocationtTime objects in this location
  #
  # returns an Array
  def all_time_slots
    LocationTime.where_match("location_id", id, "==")
  end
  
  # returns Array of all the location-times for this movie
  #
  # returns Array
  def location_times
    LocationTime.where_match("location_id", id, "==")
  end
  
  def self.where_available(available=true)
    if available
     Location.as_objects(CONNECTION.execute("SELECT COUNT(*) Loc, *  FROM locationtimes INNER JOIN locations ON locationtimes.location_id = locations.id GROUP BY locations.id, locations.name HAVING COUNT(*) < locations.num_time_slots;"))
   else
     Location.as_objects(CONNECTION.execute("SELECT COUNT(*) Loc, *  FROM locationtimes INNER JOIN locations ON locationtimes.location_id = locations.id GROUP BY locations.id, locations.name HAVING COUNT(*) >= locations.num_time_slots;"))
   end
    
  end
  
  def self.ok_to_delete?(id)
    if LocationTime.where_match("location_id", id, "==").length > 0
        false
    else
        true
    end
  end
  
  # put your business rules here, and it returns Boolean to indicate if it is valid
  #
  # returns Boolean
  def valid?
    @errors = []
    # check thename exists and is not empty
    if name.empty?
      @errors << {message: "Name cannot be empty.", variable: "name"}
    end
    
    # checks the number of time slots
    if num_time_slots.to_s.empty?
      @errors << {message: "Number of time slots cannot be empty.", variable: "num_time_slots"}
    elsif num_time_slots.is_a? Integer
      if num_time_slots > max_num_time_slots || num_time_slots < 0
        @errors << {message: "You must have between 0 and #{max_num_time_slots}.", variable: "num_time_slots"}
      end
    else
      @errors << {message: "Number of staff must be a number.", variable: "num_time_slots"}
    end
    
    # check number of seats exists and is an integer > 0
    if num_seats.to_s.empty?
      @errors << {message: "Number of seats cannot be empty.", variable: "num_seats"}
    elsif num_seats.is_a? Integer
      if num_seats < 1
        @errors << {message: "Number of seats must be a number greater than 0.", variable: "num_seats"}
      end
    else
      @errors << {message: "Number of seats must be a number.", variable: "num_seats"}
    end

    # check number of staff exists and is an integer > 0
    if num_staff.to_s.empty?
      @errors << {message: "Number of staff cannot be empty.", variable: "num_staff"}
    elsif num_staff.is_a? Integer
      if num_staff < 1
        @errors << {message: "Number of staff must be a number greater than 0.", variable: "num_staff"}
      end
    else
      @errors << {message: "Number of staff must be a number.", variable: "num_staff"}
    end
    # returns whether @errors is empty
    @errors.empty?
  end
  
end