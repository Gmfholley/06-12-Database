require "minitest/autorun"
require_relative "timeslot.rb"

class TimeSlotTest < Minitest::Test
  # One of my specs is that the tip_amount method should blah blah blah.
  
  def test_initialize
    timeslot = TimeSlot.new("id" => 1, "time" => 12)
    assert_equal(12, timeslot.time_slot)
    
    timeslot2 = TimeSlot.new(id: 1, time: 12)
    assert_equal(12, timeslot2.time_slot)
    
  end

  def test_crud
    t = TimeSlot.new( name: "test")
    assert_equal(Fixnum, t.save_record.class)
    t.name = "Pur"
    assert_equal(Array, t.update_record.class)
    
    assert_equal(true, TimeSlot.ok_to_delete?(t.id))
    
    assert_equal(Array, TimeSlot.delete_record(t.id).class)
    assert_equal(TimeSlot, TimeSlot.all.first.class)
  end
  
  # tested ok to to delete previously above
  def test_ok_to_delete
    assert_equal(false, TimeSlot.ok_to_delete?(11))
  end
  
  def test_valid
    # Can't be nil
    t = TimeSlot.new(name: nil)
    t.valid?
    assert_equal(1, t.errort.length)
    
    # can't be empty strings
    t = TimeSlot.new(name: "")    
    t.valid?
    assert_equal(1, t.errort.length)
    
    # can't be whatever is created when no args are passed
    t = TimeSlot.new()
    t.valid?
    assert_equal(1, t.errort.length)
  end
  
end