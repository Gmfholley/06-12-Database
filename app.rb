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
      user_wants = main_menu.run_menu
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
      user_wants = movie_menu.run_menu
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
      user_wants = theatre_menu.run_menu
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
      user_wants = loc_time_menu.run_menu
      call_method(method_name: user_wants[0], params: user_wants[1])
  end
  
  def call_method(method_name: method, params: para = nil)
      if para.nil?
        self.method(method_name).call
      else
        self.method(method_name).call(para)
      end
  end
  
  ############Create Methods
  def create_loc_time
    all_locs = Location.as_objects(Location.all)
    create_menu = Menu.new("Pick which location you are booking for.")
    all_locs.each_with_index do |loc, x|
      create_menu.add_menu_item({key_user_returns: x, user_message: loc.to_s, do_if_chosen:    
      [loc.id]})
    end
    loc = create_menu.run_menu
    
    
    all_times = TimeSlot.as_objects(TimeSlot.all)
    create_menu = Menu.new("Pick which time slot you are booking for.")
    all_times.each_with_index do |time, x|
      create_menu.add_menu_item({key_user_returns: x, user_message: time.to_s, do_if_chosen:    
      [time.id]})
    end
    time = create_menu.run_menu
    
    all_movies = Movie.as_objects(Movie.all)
    create_menu = Menu.new("Pick which movie you are booking for.")
    all_movies.each_with_index do |movie, x|
      create_menu.add_menu_item({key_user_returns: x, user_message: movie.to_s, do_if_chosen:    
      [movie.id]})
    end
    movie = create_menu.run_menu
    
    begin 
      l = LocationTimeSlot.new(location_id: loc, timeslot_id: time, movie_id: movie)
      l.save
    rescue Exception => msg
      puts msg
    end
    

    # @location_id = args[:location_id] || args["location_id"]
    # @timeslot_id = args[:timeslot_id] || args["timeslot_id"]
    # @movie_id = args[:movie_id] || args["movie_id"]
    # @num_tickets_sold = args["num_tickets_sold"] || 0
    
  end
  
  
  
  
  
  
  ############Show Methods
  
  def show_loc_times
    puts LocationTimeSlot.as_objects(LocationTimeSlot.all)
    loc_time_menu
  end
  
  def show_theatres
    puts Location.as_objects(Location.all)
    theatre_menu
  end
  def show_movie
    puts Movie.as_objects(Movie.all)
    movie_menu
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



