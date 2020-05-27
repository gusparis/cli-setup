# frozen_string_literal: true

require 'yaml'

# Yaml serializer - deserializer module
class YamlSerializer
  # Load object from file.
  # Silent: always returns an object
  def load_file(file)
    puts "Loading yaml from file: #{file}" if $verbose
    loaded_data = {}
    begin
      loaded_data = YAML.safe_load File.read file if File.exist? file
    rescue StandardError
      puts "Error parsing file: #{file}. #{$ERROR_INFO}" if $verbose
    ensure
      loaded_data
    end
  end

  # Save object to yaml file.
  # Throw exception if there is an error.
  def save_file(file, data)
    puts "Saving to yaml file: #{file}" if $verbose
    begin
      File.open(file, 'w') do |f|
        f.write data.to_yaml
      end
    rescue StandardError
      puts "Error saving yaml file: #{file}. #{$ERROR_INFO}" if $verbose
      raise
    end
  end
end
