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


puts "Hello!  What do you want to do with these movies?"


main_menu = Menu.new("What would you like to work on?")
main_menu.add_menu_item({key_user_returns: 1, user_message: "Work with movies.", do_if_chosen:  ["work_with_movies"]})
main_menu.add_menu_item({key_user_returns: 2, user_message: "Work with theatres.", do_if_chosen: ["work_with_movie_locations"]})
main_menu.add_menu_item({key_user_returns: 2, user_message: "Schedule movie time slots by theatre.", do_if_chosen: ["schedule_movie_time_slots"]})





movie_menu = Menu.new("What would you like to do with movies?")
movie_menu.add_menu_item({key_user_returns: 1, user_message: "Create a movie.", do_if_chosen: ["create_movie"]})
movie_menu.add_menu_item({key_user_returns: 2, user_message: "Update a movie.", do_if_chosen: ["update_movie"]})
movie_menu.add_menu_item({key_user_returns: 3, user_message: "Show me movies.", do_if_chosen: ["show_movies"]})
movie_menu.add_menu_item({key_user_returns: 4, user_message: "Delete a movie.", do_if_chosen: ["delete_movie"]})


theatre_menu = Menu.new("What would you like to do with theatres?")
theatre_menu.add_menu_item({key_user_returns: 1, user_message: "Create a theatre.", do_if_chosen: ["create_theatre"]})
theatre_menu.add_menu_item({key_user_returns: 2, user_message: "Update a theatre.", do_if_chosen: ["update_theatre"]})
theatre_menu.add_menu_item({key_user_returns: 3, user_message: "Show me theatres.", do_if_chosen: ["show_theatres"]})
theatre_menu.add_menu_item({key_user_returns: 4, user_message: "Delete a theatre.", do_if_chosen: ["delete_theatre"]})

loc_time_menu = Menu.new("What would you like to do with movie time/theatre slots?")
loc_time_menu.add_menu_item({key_user_returns: 1, user_message: "Create a new theatre/time slot.", do_if_chosen: ["create_loc_time"]})
loc_time_menu.add_menu_item({key_user_returns: 2, user_message: "Update a theatre/time slot.", do_if_chosen: ["update_loc_time"]})
loc_time_menu.add_menu_item({key_user_returns: 3, user_message: "Show me theatre/time slots.", do_if_chosen: ["show_loc_times"]})
loc_time_menu.add_menu_item({key_user_returns: 4, user_message: "Delete a theatre/time slot.", do_if_chosen: ["delete_loc_time"]})




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



