require_relative 'database_connector.rb'

class Location
  include DatabaseConnector

  attr_reader :name, :num_seats, :num_staff, :num_time_slots

  
  def initialize(args)
    @id = ""
    @name = args[:name]
    @num_seats = args[:num_seats]
    @num_staff = args[:num_staff]
    @num_time_slots = args[:num_time_slots]
  end
  
  
  
  
end