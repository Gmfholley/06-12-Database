require_relative 'database_connector.rb'
require_relative 'location.rb'
require_relative 'rating.rb'
require_relative 'studio.rb'
require_relative 'timeslot.rb'
require_relative 'movie.rb'
require_relative 'location_time.rb'
require_relative 'menu.rb'
require_relative 'menu_item.rb'


CONNECTION=SQLite3::Database.new("movies.db")
CONNECTION.results_as_hash = true
CONNECTION.execute("PRAGMA foreign_keys = ON;")

class DatabaseDriver

  def main_menu
      main_menu = Menu.new("What would you like to work on?")
      main_menu.add_menu_item({key_user_returns: 1, user_message: "Work with movies.", do_if_chosen:  ["movie_menu"]})
      main_menu.add_menu_item({key_user_returns: 2, user_message: "Work with theatres.", do_if_chosen: ["theatre_menu"]})
      main_menu.add_menu_item({key_user_returns: 3, user_message: "Schedule movie time slots by theatre.", do_if_chosen: ["loc_time_menu"]})
      main_menu.add_menu_item({key_user_returns: 4, user_message: "Run an analysis on my theatres.", do_if_chosen: ["analyze_menu"]})
      user_wants = run_menu(main_menu)
      params = user_wants.slice(1..-1) if user_wants.length > 1
      call_method(user_wants.slice(0), params)
  end
    
  def movie_menu
      movie_menu = Menu.new("What would you like to do with movies?")
      movie_menu.add_menu_item({key_user_returns: 1, user_message: "Create a movie.", do_if_chosen: ["create_movie"]})
      movie_menu.add_menu_item({key_user_returns: 2, user_message: "Update a movie.", do_if_chosen: ["update_object", Movie, "movie_menu"]})
      movie_menu.add_menu_item({key_user_returns: 3, user_message: "Show me movies.", do_if_chosen: ["show_object", Movie, "movie_menu"]})
      movie_menu.add_menu_item({key_user_returns: 4, user_message: "Delete a movie.", do_if_chosen: ["delete_object", Movie, "movie_menu"]})
      movie_menu.add_menu_item({key_user_returns: 5, user_message: "Return to main menu.", do_if_chosen: 
          ["main_menu"]})
      user_wants = run_menu(movie_menu)
      params = user_wants.slice(1..-1) if user_wants.length > 1
      call_method(user_wants.slice(0), params)
  end
  
  def theatre_menu
      theatre_menu = Menu.new("What would you like to do with theatres?")
      theatre_menu.add_menu_item({key_user_returns: 1, user_message: "Create a theatre.", do_if_chosen: ["create_theatre"]})
      theatre_menu.add_menu_item({key_user_returns: 2, user_message: "Update a theatre.", do_if_chosen: ["update_object", Location, "theatre_menu"]})
      theatre_menu.add_menu_item({key_user_returns: 3, user_message: "Show me theatres.", do_if_chosen: ["show_object", Location, "theatre_menu"]})
      theatre_menu.add_menu_item({key_user_returns: 4, user_message: "Delete a theatre.", do_if_chosen: ["delete_object", Location, "theatre_menu"]})
      theatre_menu.add_menu_item({key_user_returns: 5, user_message: "Return to main menu.", do_if_chosen: 
          ["main_menu"]})
      user_wants = run_menu(theatre_menu)
      params = user_wants.slice(1..-1) if user_wants.length > 1
      call_method(user_wants.slice(0), params)
  end
  
  def loc_time_menu
      loc_time_menu = Menu.new("What would you like to do with movie time/theatre slots?")
      loc_time_menu.add_menu_item({key_user_returns: 1, user_message: "Create a new theatre/time slot.", do_if_chosen:    
        ["create_loc_time"]})
      loc_time_menu.add_menu_item({key_user_returns: 2, user_message: "Update a theatre/time slot.", do_if_chosen: 
        ["update_object", LocationTime, "loc_time_menu"]})
      loc_time_menu.add_menu_item({key_user_returns: 3, user_message: "Show me theatre/time slots.", do_if_chosen: 
        ["show_object", LocationTime, "loc_time_menu"]})
      loc_time_menu.add_menu_item({key_user_returns: 4, user_message: "Delete a theatre/time slot.", do_if_chosen: 
        ["delete_loc_time"]})
      loc_time_menu.add_menu_item({key_user_returns: 5, user_message: "Return to main menu.", do_if_chosen: 
          ["main_menu"]})
      user_wants = run_menu(loc_time_menu)
      params = user_wants.slice(1..-1) if user_wants.length > 1
      call_method(user_wants.slice(0), params)
  end
  
  def analyze_menu
      analyze_menu = Menu.new("What would you like to see?")
      analyze_menu.add_menu_item({key_user_returns: 1, user_message: "Get all time/theatres for a particular movie.", do_if_chosen: ["get_time_location_for_movie"]})
      analyze_menu.add_menu_item({key_user_returns: 2, user_message: "Get all times for a particular theatre.", do_if_chosen: ["get_time_location_for_location"]})
      analyze_menu.add_menu_item({key_user_returns: 3, user_message: "Get all movies played at this time.", do_if_chosen: ["get_all_movies_for_this_time"]})
      analyze_menu.add_menu_item({key_user_returns: 4, user_message: "Get all time/theatres that are sold out or not sold out.", do_if_chosen: ["get_sold_time_locations"]})
      analyze_menu.add_menu_item({key_user_returns: 5, user_message: "Get all movies from a particular studio or rating.", do_if_chosen: ["get_movies_like_this"]})
      analyze_menu.add_menu_item({key_user_returns: 6, user_message: "Get all theatres that are booked or not fully booked.", do_if_chosen: ["get_available_locations"]})
      
      analyze_menu.add_menu_item({key_user_returns: 7, user_message: "Return to main menu.", do_if_chosen: 
          ["main_menu"]})
      user_wants = run_menu(analyze_menu)
      params = user_wants.slice(1..-1) if user_wants.length > 1
      call_method(user_wants.slice(0), params)
  end
  
  
  def call_method(method_name, params=nil)
      if params.nil?
        self.method(method_name).call
      else
        self.method(method_name).call(params)
      end
  end
  
  #analyze menu
  ###################
  
  def get_time_location_for_movie
    chosen_movie = user_choice_of_object_in_class(Movie)
    puts chosen_movie.location_times
    analyze_menu
  end
  
  def get_time_location_for_location
    chosen_theatre = user_choice_of_object_in_class(Location)
    puts chosen_theatre.location_times
    analyze_menu
  end
  
  def get_all_movies_for_this_time
    chosen_time = user_choice_of_object_in_class(Time)
    binding.pry
    puts chosen_time.location_times
    analyze_menu
  end
  
  def get_sold_time_locations
    create_menu  = Menu.new("Do you want to get all those that are sold out or not sold out?")
    create_menu.add_menu_item({key_user_returns: 1, user_message: "Sold out", do_if_chosen: ["sold out"]})
    create_menu.add_menu_item({key_user_returns: 2, user_message: "Not sold out", do_if_chosen: ["not sold out"]})
    choice = run_menu(create_menu)[0]
    if choice == "sold out"
      puts LocationTime.where_sold_out(true)
    else
      puts LocationTime.where_sold_out(false)
    end
    analyze_menu
  end
  
  def get_movies_like_this
    create_menu = Menu.new("What do you want to look up?")
    create_menu.add_menu_item({key_user_returns: 1, user_message: "Studios", do_if_chosen: ["studios"]})
    create_menu.add_menu_item({key_user_returns: 2, user_message: "Ratings", do_if_chosen: ["ratings"]})
    choice = run_menu(create_menu)[0]
    if choice == "studios"
      obj = user_choice_of_object_in_class(Studio)
      puts Movie.where_match("studio_id", obj.id, "==")
    elsif choice == "ratings"
      obj = user_choice_of_object_in_class(Rating)
      puts Movie.where_match("rating_id", obj.id, "==")
    else
      puts "Error: Problem with menu."
    end
    analyze_menu
  end



  def get_available_locations
    create_menu  = Menu.new("Do you want to get all available or not available?")
    create_menu.add_menu_item({key_user_returns: 1, user_message: "Available", do_if_chosen: [true]})
    create_menu.add_menu_item({key_user_returns: 2, user_message: "Not available", do_if_chosen: [false]})
    choice = run_menu(create_menu)[0]
    if choice
      puts Location.where_available(true)
    else
      puts Location.where_available(false)
    end
    analyze_menu
  end

    
  #########Update methods
  
  def update_object(args)
    class_name = args[0]
    next_method_to_call = args[1]
    object = user_choice_of_object_in_class(class_name)
    choice = user_choice_of_field(object)
    new_value = get_user_input("What should the value of #{choice} be?")
    
    if type_of_field_in_database(class_name, choice) == "INTEGER"
      new_value = new_value.to_i
    end
    
    try_to_update_database{
      object.update_record(choice, new_value)
    }
    call_method(next_method_to_call)
  end
  
  ##############Delete Methods
  # deletes the user's chosen LocationTime boejct
  # Must have a separate delete method for LocationTime because it has a composite Primary Key
  #
  # calls the location time menu again
  #
  #
  def delete_loc_time
    delete_loc = user_choice_of_object_in_class(LocationTime)
    try_to_update_database{
      LocationTime.delete_record(delete_loc.location_id, delete_loc.timeslot_id)
    }
    loc_time_menu
  end
  
  # deletes the object chosen by the user
  #
  # args - Array
  # =>    Array[0] --> class name of the object to delete
  # =>    Array[1] --> method to call next time
  #
  # calls next method to run
  def delete_object(args)
    class_name = args[0]
    next_method_to_call = args[1]
    delete_loc = user_choice_of_object_in_class(class_name)
    try_to_update_database{
      class_name.delete_record(delete_loc.id)
    }
    call_method(next_method_to_call)
  end
  
  ############Create Methods
  # gets information needed to create and save to database a LocationTime object
  #
  # calls loc_time_menu
  def create_loc_time
    is_available = false
    while !is_available
      loc = user_choice_of_object_in_class(Location)
      is_available = loc.has_available_time_slot?
      puts "That theatre is fully booked.  Try again." if !is_available
    end
    time = user_choice_of_object_in_class(Time)
    movie = user_choice_of_object_in_class(Movie)
    
    success = try_to_update_database {
      l = LocationTime.new(location_id: loc.id, timeslot_id: time, movie_id: movie)
      l.save_record
    }
    loc_time_menu
  end
  
  # gets information needed to create and save to database a Location object
  #
  # calls theatre_menu
  def create_theatre
    name = get_user_input("What is the name of the new theatre?")
    seats = get_user_input("How many seats does the theatre hold?").to_i
    staff = get_user_input("How many staff needed to run it?").to_i
    time_slots = get_user_input("How many movies can play a day?  Max of 6").to_i
    
    while time_slots > 6 ||  time_slots < 0
      time_slots = get_user_input("Invalid response.  Must be between 0 and 6.").to_i
    end  
    try_to_update_database { 
      l = Location.new(name: name, num_seats: seats, num_staff: staff, num_time_slots: time_slots)
      l.save_record
    }
    theatre_menu
  end
  
  
  
  
  # gets all the input for a movie and saves to database
  #
  # goes back to movie_menu
  def create_movie
    n = get_user_input("What is the name of the movie?")
    d = get_user_input("Enter a brief description.")
    l = get_user_input("How long is it?(in minutes)").to_i
    while l < 0
      l = get_user_input("Invalid response.  Must be greater than 0.").to_i
    end
    studio = user_choice_of_object_in_class(Studio)
    rating = user_choice_of_object_in_class(Rating)
    
    try_to_update_database{ 
      l = Movie.new(name: n, description: d, length: l, rating_id: rating, studio_id: studio)
      l.save_record
    }
    movie_menu
  end  
  
  
  ############Show Methods
  # displays all time-theatre combinations to the screen
  #
  # args - Array containing class_name in first slot and next method to call in its second slot
  #
  # calls next method
  def show_object(args)
    class_name  = args[0]
    next_method_to_call = args[1]
    puts class_name.all
    call_method(next_method_to_call)
  end

  
  private
  
  # accepts a Class and returns an instance of the object from the database that the user selects
  #
  # class_object - Class object
  #
  # returns an instance of the object
  def user_choice_of_object_in_class(class_object)
    create_menu = Menu.new("Which #{class_object.name} do you want to look up?")
    all = class_object.all
    all.each_with_index do |object, x|
      create_menu.add_menu_item({key_user_returns: x + 1, user_message: object.to_s, do_if_chosen:    
        [object]})
    end
    return run_menu(create_menu)[0]
  end
  
  # returns the field name that the user wants to change
  #
  # returns a String of the field name
  def user_choice_of_field(object)
    fields = object.database_field_names
    create_menu = Menu.new("Which field do you want to update?")
    fields.each_with_index do |field, x|
      create_menu.add_menu_item({key_user_returns: x + 1, user_message: field, do_if_chosen:    
      [field]})
    end
    run_menu(create_menu)[0]
  end
  
  # returns this object's data type
  #
  # returns a String or False if it cannot be found
  def type_of_field_in_database(class_name, field_name)
    all_fields = class_name.get_table_info
    all_fields.each do |field|
      if field["name"] == field_name
        return field["type"]
      end
    end
    false
  end
  
  # meant to be run with a block
  # tries to update the database or sends the user an error message
  #
  # returns nothing
  def try_to_update_database
    begin
      yield
    rescue Exception => msg
      puts msg
    end
  end
  
  # displays the menu
  #
  # returns menu_items
  def display_menu(menu)
    puts menu.title
    menu.menu_items.each_with_index { |item| puts "#{item.key_user_returns}.\t #{item.user_message}" }
  end
  
  # displays menu and gets user response until user quits or selects a menu item
  #
  # returns menu_items's command of what to run
  def run_menu(menu)
    display_menu(menu)
    user_choice = get_user_input(menu.user_pick_one_prompt)
    while !menu.user_input_valid?(user_choice)
      user_choice = get_user_input(menu.user_wrong_choice_prompt)
    end
    if menu.user_wants_to_quit?(user_choice)
      exit 0
    else
      menu.find_menu_item_chosen(user_choice).do_if_chosen
    end
  end
  
  # displays message and gets user input
  #
  # message - String
  #
  # returns String
  def get_user_input(message)
    puts message
    gets.chomp
  end
  
  
end


c = DatabaseDriver.new

puts c.main_menu

