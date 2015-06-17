require_relative 'database_connector.rb'

class Location
  include DatabaseConnector
  alias_method :save, :save_record
  alias_method :update_r, :update_record
  alias_method :update_f, :update_field
  
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
    @errors = []
  end

  def to_s
    "id: #{id}\tname: #{name}\tnumber of seats: #{num_seats}\tnumber of staff: #{num_staff}\tnumber of movies played a day: #{num_time_slots}"
  end
  
  def valid_num_time_slots?
    num_time_slots < max_num_time_slots && num_time_slots > 0
  end
  
  def max_num_time_slots
    CONNECTION.execute("SELECT COUNT(*) FROM times;")
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
  
  # put your business rules here, and it returns Boolean to indicate if it is valid
  #
  # returns Boolean
  def valid_data?
    @errors = []
    
    # check name exists and is not empty
    @errors << "Name cannot be empty." if name.empty?
    
    # check number of seats exists and is an integer > 0
    @errors << "Number of seats cannot be empty." if num_seats.to_s.empty?
    if num_seats.is_a? Integer
      if num_seats < 0
        @errors << "Number of seats must be greater than 0."
      end
    else
      @errors << "Number of seats must be a number." 
    end
    
    # check number of staff exists and is an integer > 0
    @errors << "Number of staff cannot be empty." if num_staff.to_s.empty?
    if num_staff.is_a? Integer
      if num_staff < 0
        @errors << "Number of staff must be greater than 0."
      end
    else
      @errors << "Number of staff must be a number." 
    end
    
    # check number of time slots to make sure they exist and are valid
    @errors << "Number of time slots cannot be empty." if num_time_slots.to_s.empty?
    if num_time_slots.is_a? Integer
      if !valid_num_time_slots?
        @errors << "You cannot have more possible time slots than are available in the day."
      end
    else
      @errors << "Number of staff must be a number." 
    end
    
  end
  
  # saves record if data is valid or returns false
  #
  # returns Truthy if saved or false if not saved
  def save_record
    if valid_data?
      #call from the module
      save
    else
      false
    end
  end
  
  # updates record if data is valid or returns false
  #
  # returns Truthy if saved or false if not saved
  def update_record
    if valid_data?
      #call from the module
      update
    else
      false
    end
  end
  
  def update_field(field_name, field_value)
    if valid_data?
  
end