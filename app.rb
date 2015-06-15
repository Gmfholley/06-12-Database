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
  
  def call_method(method_name: method, params: para = nil)
      if para.nil?
        self.method(method_name).call
      else
        self.method(method_name).call(para)
      end
  end
  
  #########Update methods
  
  def update_loc_time
    all_locs = LocationTime.as_objects(LocationTime.all)
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
    begin
      update_loc.update_record(choice, new_value)
    rescue Exception => msg
      puts msg
    end
    loc_time_menu
  end
  
  def update_theatre
    all_locs = Location.as_objects(Location.all)
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
    
    begin
      update_loc.update_record(choice, new_value)
    rescue Exception => msg
      puts msg
    end
    theatre_menu
  end
  
  def update_movie
    all_locs = Movie.as_objects(Movie.all)
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
    
    begin
      update_loc.update_record(choice, new_value)
    rescue Exception => msg
      puts msg
    end
    movie_menu
  end
  
  ##############Delete Methods
  def delete_loc_time
    all_locs = LocationTime.as_objects(LocationTime.all)
    create_menu = Menu.new("Pick which one you want to delete.")
    all_locs.each_with_index do |loc, x|
      create_menu.add_menu_item({key_user_returns: x + 1, user_message: loc.to_s, do_if_chosen:    
      [loc]})
    end
    delete_loc = run_menu(create_menu)[0]
    begin
      LocationTime.delete_record(location_id: delete_loc.location_id, timeslot_id: delete_loc.timeslot_id)
    rescue Exception => msg
      puts msg
    end
    loc_time_menu
  end
  
  def delete_theatre
    all_locs = Location.as_objects(Location.all)
    create_menu = Menu.new("Pick which one you want to delete.")
    all_locs.each_with_index do |loc, x|
      create_menu.add_menu_item({key_user_returns: x + 1, user_message: loc.to_s, do_if_chosen:    
      [loc.id]})
    end
    delete_loc = run_menu(create_menu)[0]
    begin
      Location.delete_record(delete_loc)
    rescue Exception => msg
      puts msg
    end
    theatre_menu
  end
  
  def delete_movie
    all_locs = Movie.as_objects(Movie.all)
    create_menu = Menu.new("Pick which one you want to delete.")
    all_locs.each_with_index do |loc, x|
      create_menu.add_menu_item({key_user_returns: x + 1, user_message: loc.to_s, do_if_chosen:    
      [loc.id]})
    end
    delete_loc = run_menu(create_menu)[0]
    begin
      Movie.delete_record(delete_loc)
    rescue Exception => msg
      puts msg
    end
    movie_menu
  end
  
  ############Create Methods
  def create_loc_time
    all_locs = Location.as_objects(Location.all)
    create_menu = Menu.new("Pick which location you are booking for.")
    all_locs.each_with_index do |loc, x|
      create_menu.add_menu_item({key_user_returns: x + 1, user_message: loc.name, do_if_chosen:    
      [loc.id]})
    end
    loc = run_menu(create_menu)[0]
    
    
    all_times = Time.as_objects(Time.all)
    create_menu = Menu.new("Pick which time slot you are booking for.")
    all_times.each_with_index do |time, x|
      create_menu.add_menu_item({key_user_returns: x + 1, user_message: time.time_slot.to_s, do_if_chosen:    
      [time.id]})
    end
    time = run_menu(create_menu)[0]
    
    all_movies = Movie.as_objects(Movie.all)
    create_menu = Menu.new("Pick which movie you are booking for.")
    all_movies.each_with_index do |movie, x|
      create_menu.add_menu_item({key_user_returns: x + 1,user_message: movie.to_s, do_if_chosen:    
      [movie.id]})
    end
    movie = run_menu(create_menu)[0]
    
    begin 
      l = LocationTime.new(location_id: loc, timeslot_id: time, movie_id: movie)
      l.save_record
    rescue Exception => msg
      puts msg
    end
    
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
    
    begin 
      l = Location.new(name: name, num_seats: seats, num_staff: staff, num_time_slots: time_slots)
      l.save_record
    rescue Exception => msg
      puts msg
    end
    
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
    
    all_studios = Studio.as_objects(Studio.all)
    create_menu = Menu.new("Pick which studio the file belongs to")
    all_studios.each_with_index do |studio, x|
      create_menu.add_menu_item({key_user_returns: x + 1,user_message: studio.name, do_if_chosen:    
      [studio.id]})
    end
    create_menu.add_menu_item({key_user_returns: all_studios.length, user_message: "Studio is not listed.", do_if_chosen: "create_studio"})
    studio = run_menu(create_menu)[0]
    
    all_ratings = Rating.as_objects(Rating.all)
    create_menu = Menu.new("Pick what the movie is rated")
    all_ratings.each_with_index do |r, x|
      create_menu.add_menu_item({key_user_returns: x + 1,user_message: r.rating, do_if_chosen:    
      [r.id]})
    end
    rating = run_menu(create_menu)[0]
    
    if studio == "create_studio"
      puts "Sorry.  I did not create this menu item yet." # create_studio
    end
    
    begin 
      l = Movie.new(name: n, description: d, length: l, rating_id: rating, studio_id: studio)
      l.save_record
    rescue Exception => msg
      puts msg
    end
    
    movie_menu
    # @id = args["id"] || ""
    # @name = args[:name] || args["name"]
    # @description = args[:description] || args["description"]
    # @rating_id = args[:rating_id] || args["rating_id"]
    # @studio_id = args[:studio_id] || args["studio_id"]
    # @length = args[:length] || args["length"]
    
  end  
  
  
  ############Show Methods
  
  def show_loc_times
    puts LocationTime.as_objects(LocationTime.all)
    loc_time_menu
  end
  
  def show_theatres
    puts Location.as_objects(Location.all)
    theatre_menu
  end
  def show_movies
    puts Movie.as_objects(Movie.all)
    movie_menu
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



