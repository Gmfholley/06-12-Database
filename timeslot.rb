require_relative 'database_connector.rb'

CONNECTION=SQLite3::Database.new("movies.db")
CONNECTION.results_as_hash = true
CONNECTION.execute("PRAGMA foreign_keys = ON;")

class TimeSlot
  include DatabaseConnector

  attr_reader :time_slot

  
  def initialize(args)
    @id = ""
    @time_slot = args[:time_slot]
  end

end