require "minitest/autorun"
require_relative "timeslot.rb"

class TimeSlotTest < Minitest::Test
  # One of my specs is that the tip_amount method should blah blah blah.
  
  def test_initialize
    timeslot = TimeSlot.new("id" => 1, "time_slot" => 12)
    assert_equal(12, timeslot.time_slot)
    
    timeslot2 = TimeSlot.new(id: 1, time_slot: 12)
    assert_equal(12, timeslot2.time_slot)
    
  end
  
end