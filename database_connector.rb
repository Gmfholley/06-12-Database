require 'sqlite3'
require 'active_support'
require 'active_support/core_ext/string/filters.rb'
require 'active_support/inflector.rb'

module DatabaseConnector
  
  module ClassDatabaseConnector    
    # connects to the database
    #
    # database_name    - String representing the database name (and relative path)
    #
    # returns Object representing the database CONNECTION 
    # def connection_to_database(database_name)
    #   CONNECTION = SQLite3::Database.new(database_name)
    #   CONNECTION.results_as_hash = true
    # end

    # creates a table with field names and types as provided
    #
    # field_names_and_types   - Array of the column names
    #
    # returns nothing
    def create_table(field_names_and_types)
      stringify = create_string_of_field_names_and_types(field_names_and_types)
      CONNECTION.execute("CREATE TABLE IF NOT EXISTS #{self.to_s.pluralize} (#{stringify});")
    end
  
    # returns a stringified version of this table, optimizied for SQL statements
    #
    # Example: 
    #           [["id", "integer"], ["name", "text"], ["grade", "integer"]]
    #        => "id INTEGER PRIMARY KEY, name TEXT, grade INTEGER" 
    #
    # field_names_and_types     - Array of Arrays of field names and their types - first Array assumed to be Primary key
    #
    # returns String
    def create_string_of_field_names_and_types(field_names_and_types)
      field_names_and_types.each do |array|
        binding.pry
        array[1] = array[1].upcase + ","
      end
      field_names_and_types.last[1] = field_names_and_types.last[1].remove(/,/)
      if !field_names_and_types.first[1].include?("PRIMARY KEY")
        field_names_and_types.first[1] = field_names_and_types.first[1].remove(/,/) + " PRIMARY KEY,"
      end
      field_names_and_types.join(" ")
    end
  
    ####### NOTE: THIS METHOD DOE SNOT WORK BECAUSE YOU CANNOT GET THE FIELDNAMES
    # # creates a new record in the table
    # #
    # # records                 - multi-dimensional Array of column names, each row representing a new record
    # #
    # # returns nothing
    # def create_new_records(records)
    # ####
    #   (0..records.length - 1).each do |x|
    #     record_as_string = add_quotes_to_string(records[x].join("', '"))
    #     CONNECTION.execute("INSERT INTO #{self.to_s.pluralize} (#{string_field_names}) VALUES (#{record_as_string});")
    #   end
    # end
    
    # deletes the record matching the primary key
    #
    # key_id             - Integer of the value of the record you want to delete
    #
    # returns nothing
    def delete_record(key_id)
      CONNECTION.execute("DELETE FROM #{self.to_s.pluralize} WHERE id = #{key_id};")
    end

    # returns all records in database
    #
    # returns Array of a Hash of the resulting records
    def all
      CONNECTION.execute("SELECT * FROM #{self.to_s.pluralize};")
    end
    
    # retrieves a record matching the id
    #
    # returns this object's Hash
    def create_from_database(id)
      rec = CONNECTION.execute("SELECT * FROM #{self.to_s.pluralize} WHERE id = #{id};")
      self.new(rec[0])
    end
    
    # convert Hash records to Objects
    #
    # returns an Array of objects
    def as_objects(hashes)
      as_object = []
      hashes.each do |hash|
        as_object.push(self.new(hash))
      end
      as_object
    end
    
    # retrieves all records in this table where field name and field value have this relationship
    #
    # fieldname       - String of the field name in this table
    # field_value     - String or Integer of this field value in the table
    # relationship    - String of the relationship (ie: ==, >=, <=, !)
    #
    # returns an Array of hashes
    def all_that_match(field_name, field_value, relationship)
      if field_value.is_a? String
        field_value = add_quotes_to_string(field_value)
      end
      CONNECTION.execute("SELECT * FROM #{self.to_s.pluralize} WHERE #{field_name} #{relationship} #{field_value};")
    end
    
    # adds '' quotes around a string for SQL statement
    #
    # Example: 
    #
    #        text
    #     => 'text'
    # 
    # string  - String
    #
    # returns a String
    def add_quotes_to_string(string)
      string = "'#{string}'"
    end
  end
  ################################################################################
  # End of Class Module Methods
  
  
  # Extends ClassDatabaseMethods
  #
  # Parameters:
  # base: String: name of the class being included in.
  #
  # Returns:
  # nil
  #
  # State Changes:
  # None
  def self.included(base)
    base.extend ClassDatabaseConnector
  end
  
  # returns the table name - the plural of the object's class
  def table
    self.class.to_s.pluralize
  end
  
  # returns a String of the database_field_names for SQL
  def database_field_names
    attributes = []
    instance_variables.each do |i|
      unless i == "@id".to_sym
        attributes << i.to_s.delete("@")
      end
    end
    attributes
  end
  
  #string of field names
  def string_field_names
    database_field_names.join(', ')
  end
  
  
  # returns an Array of this object's parameters
  #
  # returns an Array
  def self_values
    self_values = []
    database_field_names.each do |params|
      unless params == "id"
        self_values << self.send(params)
      end
    end
    self_values
  end
  
  # string of this object's parameters for SQL
  def stringify_self
    stringify = ""
    self_values.each_with_index do |param, index|
      case index
      when 0
        joiner = ""
      else
        joiner = ", "
      end
      if param.is_a? Integer
        stringify += joiner + param.to_s
      elsif param.is_a? String
        stringify += joiner + "'#{param}'"
      else
        stringify = joiner + "'#{param.to_s}'"
      end
    end
    stringify
  end
  
  # checks if this object has been saved to the database yet
  #
  # returns Boolean
  def saved_already?
    ! @id == ""
  end
  
  # creates a new record in the table for this object
  #
  # returns Boolean if unable to save
  def save_record
    if @id == ""
      CONNECTION.execute("INSERT INTO #{table} (#{string_field_names}) VALUES (#{stringify_self});")
      @id = CONNECTION.last_insert_row_id if @id == ""
      true
    else
      false
    end
  end

  # updates the field of one column if records meet criteria
  #
  # change_field            - String of the change field
  # change_value            - Value (Integer or String) to change in the change field
  #
  # returns nothing
  def update_record(change_field, change_value)
    if change_value.is_a? String
      change_value = add_quotes_to_string(change_value)
    end
    CONNECTION.execute("UPDATE #{table} SET #{change_field} = #{change_value} WHERE id = #{@id};")
  end
  
  # returns the result of an array where field_name = field_value
  #
  # other_table      - String of the other table name
  # other_field_name - String of the field name of this object's ID in another table
  #
  # returns Array of a Hash of the resulting records
  def where_this_id_in_another_table(other_table, other_field_name)
    CONNECTION.execute("SELECT * FROM #{other_table} WHERE #{other_field_name} == #{@id};")
  end
  
  # returns the result of an array where field_name = field_value
  #
  # other_table      - String of the other table name
  # other_field_name - String of the field name of this parameter in the other table
  # this_parameter -   String or Integer of the value of this parameter for this object
  #
  # returns Array of a Hash of the resulting records
  def where_this_parameter_in_another_table(other_table, this_parameter, other_field_name)
    if this_parameter.is_a? String
      this_paramter = add_quotes_to_string(this_parameter)
    end
    CONNECTION.execute("SELECT * FROM #{other_table} WHERE #{other_field_name} == #{this_parameter};")
  end
  
  # adds '' quotes around a string for SQL statement
  #
  # Example: 
  #
  #        text
  #     => 'text'
  # 
  # string  - String
  #
  # returns a String
  def add_quotes_to_string(string)
    string = "'#{string}'"
  end

end

