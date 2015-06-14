require_relative 'database_connector.rb'


class Studio
  include DatabaseConnector
    
  attr_reader :name

  
  def initialize(args)
    @id = ""
    @name = args[:name]
  end
  
  
  
  
end