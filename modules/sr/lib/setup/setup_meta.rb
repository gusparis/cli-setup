# frozen_string_literal: true

# Metadata about setup file
class SetupMeta
  attr_reader :file_version, :app_version, :name, :description, :ascii_art
  def initialize(file_version, app_version, name, description, ascii_art)
    @file_version = file_version
    @app_version = app_version
    @name = name
    @description = description
    @ascii_art = ascii_art
  end

  # Create Setup Metadata from json-object
  def self.from_json_object(json_object)
    new json_object['fileVersion'],
        json_object['appVersion'],
        json_object['name'],
        json_object['description'],
        json_object['asciiArt']
  end
end
