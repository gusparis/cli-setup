# frozen_string_literal: true

require_relative './implementations/json_serializer'
require_relative './implementations/yaml_serializer'

# Defines the serializer/deserializer interface.
class Serializer
  class UnsupportedFileTypeError < StandardError; end
  # Accepts a serializer implementation through the constructor
  def initialize(serializer_implementation)
    @serializer_implementation = serializer_implementation
    puts "Initialized serializer using: #{file.class}" if $verbose
  end

  # Creates serializer according to the file extension (Mime type)
  # Throws UnsupportedFileTypeError when invalid type is provided.
  def self.create_from_mime_type(filename)
    case extension = filename.split('.').last
    when 'json'
      new JsonSerializer.new
    when 'yml', 'yaml'
      new YamlSerializer.new
    else
      raise UnsupportedFileTypeError.new, extension
    end
  end

  # Load serialized data from file.
  # Silent: always returns an object
  def load_file(file)
    @serializer_implementation.load_file file
  end

  # Save json to file.
  # Throw exception if there is an error.
  def save_file(file, data)
    @serializer_implementation.save_file(file, data)
  end
end
