require_relative 'database_connector.rb'


class Movie
  include DatabaseConnector
  
  attr_accessor :name, :description, :rating_id, :studio_id, :length

  
  def initialize(args)
    @id = ""
    @name = args[:name]
    @description = args[:description]
    @rating_id = args[:rating_id]
    @studio_id = args[:studio_id]
    @length = args[:length]
  end
  
  
  
  
end