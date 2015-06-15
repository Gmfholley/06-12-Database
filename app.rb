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
    binding.pry
      main_menu = Menu.new("What would you like to work on?")
      main_menu.add_menu_item({key_user_returns: 1, user_message: "Work with movies.", do_if_chosen:  ["movie_menu"]})
      main_menu.add_menu_item({key_user_returns: 2, user_message: "Work with theatres.", do_if_chosen: ["theatre_menu"]})
      main_menu.add_menu_item({key_user_returns: 3, user_message: "Schedule movie time slots by theatre.", do_if_chosen: ["loc_time_menu"]})
      main_menu.add_menu_item({key_user_returns: 4, user_message: "Run an analysis on my theatres.", do_if_chosen: ["analyze_menu"]})
      user_wants = run_menu(main_menu)
      call_method(method_name: user_wants[0], params: user_wants[1])
  end
    
  def movie_menu
      movie_menu = Menu.new("What would you like to do with movies?")
      movie_menu.add_menu_item({key_user_returns: 1, user_message: "Create a movie.", do_if_chosen: ["create_movie"]})
      movie_menu.add_menu_item({key_user_returns: 2, user_message: "Update a movie.", do_if_chosen: ["update_movie"]})
      movie_menu.add_menu_item({key_user_returns: 3, user_message: "Show me movies.", do_if_chosen: ["show_movies"]})
      movie_menu.add_menu_item({key_user_returns: 4, user_message: "Delete a movie.", do_if_chosen: ["delete_movie"]})
      movie_menu.add_menu_item({key_user_returns: 5, user_message: "Return to main menu.", do_if_chosen: 
          ["main_menu"]})
      user_wants = run_menu(movie_menu)
      call_method(method_name: user_wants[0], params: user_wants[1])
  end
  
  def theatre_menu
      theatre_menu = Menu.new("What would you like to do with theatres?")
      theatre_menu.add_menu_item({key_user_returns: 1, user_message: "Create a theatre.", do_if_chosen: ["create_theatre"]})
      theatre_menu.add_menu_item({key_user_returns: 2, user_message: "Update a theatre.", do_if_chosen: ["update_theatre"]})
      theatre_menu.add_menu_item({key_user_returns: 3, user_message: "Show me theatres.", do_if_chosen: ["show_theatres"]})
      theatre_menu.add_menu_item({key_user_returns: 4, user_message: "Delete a theatre.", do_if_chosen: ["delete_theatre"]})
      theatre_menu.add_menu_item({key_user_returns: 5, user_message: "Return to main menu.", do_if_chosen: 
          ["main_menu"]})
      user_wants = run_menu(theatre_menu)
      call_method(method_name: user_wants[0], params: user_wants[1])
  end
  
  def loc_time_menu
      loc_time_menu = Menu.new("What would you like to do with movie time/theatre slots?")
      loc_time_menu.add_menu_item({key_user_returns: 1, user_message: "Create a new theatre/time slot.", do_if_chosen:    
        ["create_loc_time"]})
      loc_time_menu.add_menu_item({key_user_returns: 2, user_message: "Update a theatre/time slot.", do_if_chosen: 
        ["update_loc_time"]})
      loc_time_menu.add_menu_item({key_user_returns: 3, user_message: "Show me theatre/time slots.", do_if_chosen: 
        ["show_loc_times"]})
      loc_time_menu.add_menu_item({key_user_returns: 4, user_message: "Delete a theatre/time slot.", do_if_chosen: 
        ["delete_loc_time"]})
      loc_time_menu.add_menu_item({key_user_returns: 5, user_message: "Return to main menu.", do_if_chosen: 
          ["main_menu"]})
      user_wants = run_menu(loc_time_menu)
      call_method(method_name: user_wants[0], params: user_wants[1])
  end
  
  def analyze_menu
      analyze_menu = Menu.new("What would you like to see?")
      analyze_menu.add_menu_item({key_user_returns: 1, user_message: "Get all time/theatres for a particular movie.", do_if_chosen: ["get_time_location_for_movie"]})
      analyze_menu.add_menu_item({key_user_returns: 2, user_message: "Get all times for a particular theatre.", do_if_chosen: ["get_time_location_for_location"]})
      analyze_menu.add_menu_item({key_user_returns: 3, user_message: "Get all movies played at this time.", do_if_chosen: ["get_all_movie_times"]})
      analyze_menu.add_menu_item({key_user_returns: 4, user_message: "Get all time/theatres that are sold out or not sold out.", do_if_chosen: ["get_sold_time_locations"]})
      analyze_menu.add_menu_item({key_user_returns: 5, user_message: "Get all movies from a particular studio or rating.", do_if_chosen: ["get_movies_like_this"]})
      analyze_menu.add_menu_item({key_user_returns: 6, user_message: "Get all theatres that are booked or not fully booked.", do_if_chosen: ["get_available_locations"]})
      
      analyze_menu.add_menu_item({key_user_returns: 7, user_message: "Return to main menu.", do_if_chosen: 
          ["main_menu"]})
      user_wants = run_menu(analyze_menu)
      call_method(method_name: user_wants[0], params: user_wants[1])
  end
  
  
  def call_method(method_name: method, params: para = nil)
      if para.nil?
        self.method(method_name).call
      else
        self.method(method_name).call(para)
      end
  end
  
  #analyze menu
  ###################
  
  def get_time_location_for_movie
    create_menu = Menu.new("Pick which movie you want to get time/theatres for.")
    all = Movie.all
    all.each_with_index do |movie, x|
      create_menu.add_menu_item({key_user_returns: x + 1, user_message: movie.to_s, do_if_chosen:    
        [movie]})
    end
    chosen_movie = run_menu(create_menu)[0]
    
    puts chosen_movie.location_times
    analyze_menu
  end
  
  def get_time_location_for_location
    create_menu = Menu.new("Pick which theatre you want to get time/theatres for.")
    all = Location.all
    all.each_with_index do |theatre, x|
      create_menu.add_menu_item({key_user_returns: x + 1, user_message: theatre.to_s, do_if_chosen:    
        [theatre]})
    end
    chosen_theatre = run_menu(create_menu)[0]
    puts chosen_theatre.location_times
    analyze_menu
  end
  
  def get_all_movie_times
    create_menu = Menu.new("Pick which time you want to look at.")
    all = Time.all
    all.each_with_index do |time, x|
      create_menu.add_menu_item({key_user_returns: x + 1, user_message: time.time_slot, do_if_chosen:    
        [time]})
    end
    chosen_time = run_menu(create_menu)[0]
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
  end
  
  
  #########Update methods
  
  def update_loc_time

    all_locs = LocationTime.all
    create_menu = Menu.new("Pick which one you want to update.")
    all_locs.each_with_index do |loc, x|
      create_menu.add_menu_item({key_user_returns: x + 1, user_message: loc.to_s, do_if_chosen:    
        [loc]})
    end
    update_loc = run_menu(create_menu)[0]


    fields = update_loc.database_field_names
    create_menu = Menu.new("Which field do you want to update?")
    fields.each_with_index do |field, x|
      create_menu.add_menu_item({key_user_returns: x + 1, user_message: field, do_if_chosen:    
      [field]})
    end
    choice = run_menu(create_menu)[0]
    new_value = get_user_input("What should the value of #{choice} be?")
    ###### PROBLEM HERE GETTING INTEGERS
    try_to_update_database{
      update_loc.update_record(choice, new_value)
    }
    loc_time_menu
  end
  
  def update_theatre
    all_locs = Location.all
    create_menu = Menu.new("Pick which one you want to update.")
    all_locs.each_with_index do |loc, x|
      create_menu.add_menu_item({key_user_returns: x + 1, user_message: loc.to_s, do_if_chosen:    
      [loc]})
    end
    update_loc = run_menu(create_menu)[0]
    
    
    fields = update_loc.database_field_names
    create_menu = Menu.new("Which field do you want to update?")
    fields.each_with_index do |field, x|
      create_menu.add_menu_item({key_user_returns: x + 1, user_message: field, do_if_chosen:    
      [field]})
    end
    choice = run_menu(create_menu)[0]
    new_value = get_user_input("What should the value of #{choice} be?")
    
    try_to_update_database{
      update_loc.update_record(choice, new_value)
    }
    theatre_menu
  end
  
  def update_movie
    all_locs = Movie.all
    create_menu = Menu.new("Pick which one you want to update.")
    all_locs.each_with_index do |loc, x|
      create_menu.add_menu_item({key_user_returns: x + 1, user_message: loc.to_s, do_if_chosen:    
      [loc]})
    end
    update_loc = run_menu(create_menu)[0]
    
    
    fields = update_loc.database_field_names
    create_menu = Menu.new("Which field do you want to update?")
    fields.each_with_index do |field, x|
      create_menu.add_menu_item({key_user_returns: x + 1, user_message: field, do_if_chosen:    
      [field]})
    end
    choice = run_menu(create_menu)[0]
    new_value = get_user_input("What should the value of #{choice} be?")
    
    try_to_update_database {update_loc.update_record(choice, new_value)}
    movie_menu
  end
  
  ##############Delete Methods
  def delete_loc_time
    all_locs = LocationTime.all
    create_menu = Menu.new("Pick which one you want to delete.")
    all_locs.each_with_index do |loc, x|
      create_menu.add_menu_item({key_user_returns: x + 1, user_message: loc.to_s, do_if_chosen:    
      [loc]})
    end
    delete_loc = run_menu(create_menu)[0]
    try_to_update_database{
      LocationTime.delete_record(location_id: delete_loc.location_id, timeslot_id: delete_loc.timeslot_id)
    }
    
    loc_time_menu
  end
  
  def delete_theatre
    all_locs = Location.all
    create_menu = Menu.new("Pick which one you want to delete.")
    all_locs.each_with_index do |loc, x|
      create_menu.add_menu_item({key_user_returns: x + 1, user_message: loc.to_s, do_if_chosen:    
      [loc.id]})
    end
    delete_loc = run_menu(create_menu)[0]
    try_to_update_database{
      Location.delete_record(delete_loc)
    }
    
    theatre_menu
  end
  
  def delete_movie
    all_locs = Movie.all
    create_menu = Menu.new("Pick which one you want to delete.")
    all_locs.each_with_index do |loc, x|
      create_menu.add_menu_item({key_user_returns: x + 1, user_message: loc.to_s, do_if_chosen:    
      [loc.id]})
    end
    delete_loc = run_menu(create_menu)[0]
    try_to_update_database {Movie.delete_record(delete_loc)}
    movie_menu
  end
  
  ############Create Methods
  def create_loc_time
    is_available = false
    while !is_available
      all_locs = Location.all
      create_menu = Menu.new("Pick which location you are booking for.")
      all_locs.each_with_index do |loc, x|
        create_menu.add_menu_item({key_user_returns: x + 1, user_message: loc.name, do_if_chosen:    
        [loc]})
      end
      loc = run_menu(create_menu)[0]
      is_available = loc.has_available_time_slot?
      puts "That theatre is fully booked.  Try again." if !is_available
    end
    
    
    all_times = Time.all
    create_menu = Menu.new("Pick which time slot you are booking for.")
    all_times.each_with_index do |time, x|
      create_menu.add_menu_item({key_user_returns: x + 1, user_message: time.time_slot.to_s, do_if_chosen:    
      [time.id]})
    end
    time = run_menu(create_menu)[0]
    
    all_movies = Movie.all
    create_menu = Menu.new("Pick which movie you are booking for.")
    all_movies.each_with_index do |movie, x|
      create_menu.add_menu_item({key_user_returns: x + 1,user_message: movie.to_s, do_if_chosen:    
      [movie.id]})
    end
    movie = run_menu(create_menu)[0]
    try_to_update_database {
      l = LocationTime.new(location_id: loc.id, timeslot_id: time, movie_id: movie)
      l.save_record
    }
    
    loc_time_menu
    # @location_id = args[:location_id] || args["location_id"]
    # @timeslot_id = args[:timeslot_id] || args["timeslot_id"]
    # @movie_id = args[:movie_id] || args["movie_id"]
    # @num_tickets_sold = args["num_tickets_sold"] || 0
    
  end
  
  
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
    # @id = args["id"] || ""
    # @name = args[:name] || args["name"]
    # @num_seats = args[:num_seats] || args["num_seats"]
    # @num_staff = args[:num_staff] || args["num_staff"]
    # @num_time_slots = args[:num_time_slots] || args["num_time_slots"]
    
  end
  
  
  def create_movie
    n = get_user_input("What is the name of the movie?")
    d = get_user_input("Enter a brief description.")
    l = get_user_input("How long is it?(in minutes)").to_i
    
    while l < 0
      l = get_user_input("Invalid response.  Must be greater than 0.").to_i
    end
    
    all_studios = Studio.all
    create_menu = Menu.new("Pick which studio the file belongs to")
    all_studios.each_with_index do |studio, x|
      create_menu.add_menu_item({key_user_returns: x + 1,user_message: studio.name, do_if_chosen:    
      [studio.id]})
    end
    create_menu.add_menu_item({key_user_returns: all_studios.length, user_message: "Studio is not listed.", do_if_chosen: "create_studio"})
    studio = run_menu(create_menu)[0]
    
    all_ratings = Rating.all
    create_menu = Menu.new("Pick what the movie is rated")
    all_ratings.each_with_index do |r, x|
      create_menu.add_menu_item({key_user_returns: x + 1,user_message: r.rating, do_if_chosen:    
      [r.id]})
    end
    rating = run_menu(create_menu)[0]
    
    if studio == "create_studio"
      puts "Sorry.  I did not create this menu item yet." # create_studio
    end
    
    try_to_update_database{ 
      l = Movie.new(name: n, description: d, length: l, rating_id: rating, studio_id: studio)
      l.save_record
    }
    
    movie_menu
    # @id = args["id"] || ""
    # @name = args[:name] || args["name"]
    # @description = args[:description] || args["description"]
    # @rating_id = args[:rating_id] || args["rating_id"]
    # @studio_id = args[:studio_id] || args["studio_id"]
    # @length = args[:length] || args["length"]
    
  end  
  
  
  ############Show Methods
  # displays all time-theatre combinations to the screen
  def show_loc_times
    puts LocationTime.all
    loc_time_menu
  end
  
  
  # displays all theatres (locations) to the screen
  def show_theatres
    puts Location.all
    theatre_menu
  end
  
  # displays all Movies to the screen
  def show_movies
    puts Movie.all
    movie_menu
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
  
  # try to run code and give user an error message if it doesn't work properlty
  #
  #
  
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
  
  def get_user_input(message)
    puts message
    gets.chomp
  end
  
  
end


c = DatabaseDriver.new
#c.try_to_run

# puts c.loc_time_menu
# puts c.theatre_menu
 puts c.main_menu
# puts c.movie_menu

#
# m = Movie.create_from_database(1)
# puts m.rating
# puts m.studio
# all_times = m.location_times
# puts "Here is when this movie plays:"
#
#
# all_times.each do |time|
#   puts time
#   puts "All at this location:"
#   puts time.all_at_this_location
#
#   puts "\nAll at this time:"
#   puts time.all_at_this_time
#
#   puts "\nAll at this movie:"
#   puts time.all_of_this_movie
#
# end



