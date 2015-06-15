require_relative 'database_connector.rb'

class TimeSlot
  include DatabaseConnector

  attr_reader :time_slot, :id

  
  def initialize(args)
    @id = args["id"] || ""
    @time_slot = args[:time] || args["time"]
  end

end