require "minitest/autorun"
require_relative "location_time.rb"

class LocationTimeSlotTest < Minitest::Test
  # One of my specs is that the tip_amount method should blah blah blah.
  
  
  
  def test_initialize
    loctime = LocationTimeSlot.new("location_id" => 1, "timeslot_id" => 2, "movie_id" => 3, "num_tickets_sold" => 1)  
    assert_equal(1, loctime.location_id)
    assert_equal(2, loctime.timeslot_id)
    assert_equal(3, loctime.movie_id)
    assert_equal(1, loctime.num_tickets_sold)

    # When num tickets sold is a symbol, do not let it set the number of tickets sold - that is done through normal initialization, not through updating from a hash
    loctime2 = LocationTimeSlot.new(location_id: 1, "timeslot_id": 2, "movie_id": 3, "num_tickets_sold": 1)  
    assert_equal(1, loctime2.location_id)
    assert_equal(2, loctime2.timeslot_id)
    assert_equal(3, loctime2.movie_id)
    assert_equal(0, loctime2.num_tickets_sold)
    
    # @location_id = args[:location_id] || args["location_id"]
    # @timeslot_id = args[:timeslot_id] || args["timeslot_id"]
    # @movie_id = args[:movie_id] || args["movie_id"]
    # @num_tickets_sold = 0
  end
  
  
  def test_to_s
        loctime2 = LocationTimeSlot.new(location_id: 1, "timeslot_id": 2, "movie_id": 3, "num_tickets_sold": 1)  
        loctime_s = "location:\tPurple\t\ttimeslot:\t14:30:00\t\tmovie:\tGuardians of the Galaxy"
         # "location:\t#{location}\t\ttimeslot:\t#{timeslot}\t\tmovie:\t#{movie}"
         assert_equal(loctime_s, loctime2.to_s)
  end
  
end