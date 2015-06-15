require "minitest/autorun"
require_relative "location.rb"
require_relative "location_time.rb"


CONNECTION=SQLite3::Database.new("movies.db")
CONNECTION.results_as_hash = true
CONNECTION.execute("PRAGMA foreign_keys = ON;")
class LocationTest < Minitest::Test
  # One of my specs is that the tip_amount method should blah blah blah.
  
  def test_initialize
    loc = Location.new("id" => 1, "num_seats" => 300, "num_staff" => 2, "name" => "Purple", "num_time_slots" => 2)
    assert_equal(300, loc.num_seats)
    assert_equal(2, loc.num_staff)
    assert_equal("Purple", loc.name)
    assert_equal(2, loc.num_time_slots)
    
    loc2 = Location.new( num_seats: 300, num_staff: 2, name: "Purple", num_time_slots: 2)
    assert_equal(300, loc2.num_seats)
    assert_equal(2, loc2.num_staff)
    assert_equal("Purple", loc2.name)
    assert_equal(2, loc2.num_time_slots)
    
  end
  
  def test_has_avalable_time_slot

    l = Location.create_from_database(1)
    assert_equal(false, l.has_available_time_slot?)
    assert_equal(3, l.all_time_slots.length)
  end
  
end