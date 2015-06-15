require_relative 'database_connector.rb'


class Studio
  include DatabaseConnector
    
  attr_reader :name, :id

  
  def initialize(args)
    @id = args["id"] || ""
    @name = args[:name] || args["name"]
  end
  
  
end