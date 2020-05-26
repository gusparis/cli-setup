# frozen_string_literal: true

# Define when and how to configure certain fields
class SetupRule
  attr_reader :id, :execute, :type, :options, :title, :write
  def initialize(id, execute, type, options, title, write)
    @id = id
    @execute = execute
    @type = type
    @options = options
    @title = title
    @write = write
  end

  # Create rule from json_object
  def self.from_json_object(json_object)
    new json_object['id'],
        json_object['execute'],
        json_object['type'],
        json_object['options'],
        json_object['title'],
        json_object['write']
  end

  # Create rules from json_array
  def self.rules_from_json_array(json_array)
    json_array.collect do |rule|
      from_json_object rule
    end
  end
end
