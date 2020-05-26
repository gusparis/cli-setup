# frozen_string_literal: true

require 'json-schema'
require 'json'

SETUP_FILE_SCHEMA = '../schemas/setup-file.json'

# Setup File Representation
class SetupObject
  attr_reader :meta, :rules, :files
  # Raised if setup object is missing
  class MissingSetupFileError < StandardError; end
  class InvalidSetupFileError < StandardError; end

  def initialize(meta, rules, files)
    @meta = meta
    @rules = rules
    @files = files
  end

  # Creates a Setup Object from a setup-file.json
  def self.from_file!(file_path)
    puts "loading #{file_path}" if $development

    # Validations
    unless File.exist?(file_path)
      raise MissingSetupFileError.new,
            "Can't finde setup file. Path: #{file_path}"
    end

    errors = JSON::Validator.fully_validate(SETUP_FILE_SCHEMA, file_path)
    raise InvalidSetupFileError, errors unless errors.empty?

    # Parse json
    setup_file = JSON.parse File.read(file_path)
    SetupObject.new setup_file['meta'], setup_file['rules'], setup_file['files'] 
  end
end
 