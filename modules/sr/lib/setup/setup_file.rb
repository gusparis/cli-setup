# frozen_string_literal: true

require 'json-schema'
require 'json'
require_relative 'setup_meta'
require_relative 'setup_rule'
require_relative 'setup_target'

SETUP_FILE_SCHEMA = '../schemas/setup-file.json'

# In-memory representation of setup file.
class SetupFile
  # Metadata about setup file
  # @return [SetupMeta]
  attr_reader :meta
  # Rules. Each rule define when and how to configure certain fields
  # @return [Array<SetupRule>]
  attr_reader :rules
  # Targets. Each target represent a file to configure.
  # @return [Array<SetupTarget>]
  attr_reader :targets
  # Raised if setup object is missing
  class MissingSetupFileError < StandardError; end
  class InvalidSetupFileError < StandardError; end

  def initialize(meta, rules, targets)
    @meta = meta
    @rules = rules
    @targets = targets
  end

  def self.from_json_object(json_object)
    meta = SetupMeta.from_json_object json_object['meta']
    rules = SetupRule.rules_from_json_array json_object['rules']
    files = SetupTarget.targets_from_json_array json_object['targets']
    new meta, rules, files
  end

  # Create SetupFile object from json file
  def self.from_file!(file_path)
    puts "loading #{file_path}" if $verbose

    # Validations
    unless File.exist?(file_path)
      raise MissingSetupFileError.new,
            "Can't finde setup file. Path: #{file_path}"
    end

    errors = JSON::Validator.fully_validate(SETUP_FILE_SCHEMA, file_path)
    raise InvalidSetupFileError, errors unless errors.empty?

    # Parse and use from_json_object overload
    from_json_object JSON.parse File.read(file_path)
  end
end
