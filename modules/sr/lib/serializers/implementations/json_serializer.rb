# frozen_string_literal: true

require 'json'

# Json serializer - deserializer module
class JsonSerializer
  # Load json from file.
  # Silent: always returns an object
  def load_file(file)
    puts "Loading json from file: #{file}" if $verbose
    loaded_data = {}
    begin
      loaded_data = JSON.parse File.read file if File.exist? file
    rescue JSON::ParserError
      puts "Error parsing file: #{file}. #{$ERROR_INFO}" if $verbose
    ensure
      @json_data = loaded_data
    end
  end

  # Save json to file.
  # Throw exception if there is an error.
  def save_file(file, data)
    puts "Saving to json file: #{file}" if $verbose
    begin
      File.open(file, 'w') do |f|
        f.write JSON.pretty_generate data
      end
    rescue StandardError
      puts "Error saving json file: #{file}. #{$ERROR_INFO}" if $verbose
      raise
    end
  end
end
