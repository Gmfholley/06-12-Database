require_relative 'database_connector.rb'
require_relative 'location.rb'
require_relative 'rating.rb'
require_relative 'studio.rb'
require_relative 'timeslot.rb'
require_relative 'movie.rb'
require_relative 'location_time.rb'

CONNECTION=SQLite3::Database.new("movies.db")
CONNECTION.results_as_hash = true
CONNECTION.execute("PRAGMA foreign_keys = ON;")








def work_with_movies
  
end

m = Movie.create_from_database(1)
puts m.rating
puts m.studio
all_times = m.location_times
puts "Here is when this movie plays:"


all_times.each do |time|
  puts time
  puts "All at this location:"
  puts time.all_at_this_location
  
  puts "\nAll at this time:"
  puts time.all_at_this_time
  
  puts "\nAll at this movie:"
  puts time.all_of_this_movie

end



