require 'sqlite3'
require 'active_support'
require 'active_support/core_ext/string/filters.rb'
require 'active_support/inflector.rb'

module DatabaseConnector
  
  module ClassDatabaseConnector
    # returns the table name - the plural of the object's class
    def table
      self.class.to_s.pluralize
    end
  
    # returns a String of the database_field_names for SQL
    def database_field_names
      attributes = []
      self.instance_variables.each do |i|
        attributes << i.to_s.delete("@")
      end
      attributes.join(', ')
    end
  
    # connects to the database
    #
    # database_name    - String representing the database name (and relative path)
    #
    # returns Object representing the database CONNECTION 
    def connection_to_database(database_name)
      CONNECTION = SQLite3::Database.new(database_name)
      CONNECTION.results_as_hash = true
    end

    # creates a table with field names and types as provided
    #
    # field_names_and_types   - Array of the column names
    #
    # returns nothing
    def create_table(field_names_and_types: field_names_and_types)
      stringify = create_string_of_field_names_and_types(field_names_and_types)
      CONNECTION.execute("CREATE TABLE IF NOT EXISTS #{table} (#{stringify});")
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
        array[1] = array[1].upcase + ","
      end
      field_names_and_types.last[1] = field_names_and_types.last[1].remove(/,/)
      if !field_names_and_types.first[1].include?("PRIMARY KEY")
        field_names_and_types.first[1] = field_names_and_types.first[1].remove(/,/) + " PRIMARY KEY,"
      end
      field_names_and_types.join(" ")
    end
  
    # creates a new record in the table
    #
    # records                 - multi-dimensional Array of column names, each row representing a new record
    #
    # returns nothing
    def create_new_records(records)
    ####
      (0..records.length - 1).each do |x|
        record_as_string = add_quotes_to_string(records[x].join("', '"))
        CONNECTION.execute("INSERT INTO #{table} (#{database_field_names}) VALUES (#{record_as_string});")
      end
    end
    
    # deletes the record matching the primary key
    #
    # key_id             - Integer of the value of the record you want to delete
    #
    # returns nothing
    def delete_record(key_id)
      CONNECTION.execute("DELETE FROM #{table} WHERE id = #{primary_key};")
    end

    # returns all records in database
    #
    # returns Array of a Hash of the resulting records
    def all_records
      CONNECTION.execute("SELECT #{database_field_names} FROM #{table};")
    end
    
    # returns the result of an array where field_name = field_value
    #
    # returns Array of a Hash of the resulting records
    def records_matching_this(field_name, field_value)
      if field_names.length > 1
        field_names = field_names.join(", ")
      end
      CONNECTION.execute("SELECT #{database_field_names} FROM #{table} WHERE #{field_name} == #{field_value};")
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

  # returns an Array of this object's parameters
  #
  # returns an Array
  def self_values
    self_values = []
    database_field_names.each do |params|
      self_values << self.send(params)
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
      if param.is_a?s Integer
        stringify += joiner + param
      elsif param.is_a? String
        stringify += joiner + "'#{param}'"
      else
        stringify = joiner + "'#{param.to_s}'"
      end
      stringify
  end
  
  def saved_already?
    ! @id == ""
  end
  
  # creates a new record in the table for this object
  #
  # returns nothing
  def save_record
    CONNECTION.execute("INSERT INTO #{table} (#{col_names}) VALUES (#{stringify_self});")
    @id = CONNECTION.last_insert_row_id
  end

  # updates the field of one column if records meet criteria
  #
  # change_field            - String of the change field
  # change_value            - Value (Integer or String) to change in the change field
  #
  # returns nothing
  def update_record(change_field: change_field, change_value: change_value)
    if change_value.is_a? String
      change_value = add_quotes_to_string(change_value)
    end
    CONNECTION.execute("UPDATE #{table} SET #{change_field} = #{change_value} WHERE id = #{@id};")
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

