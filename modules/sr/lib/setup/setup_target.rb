# frozen_string_literal: true

# Define setup target files
class SetupTarget
  attr_reader :env, :path, :alias
  def initialize(env, path, alias_)
    @env = env
    @path = path
    @alias = alias_
  end

  # Create target from json-object
  def self.from_json_object(json_object)
    new json_object['env'],
        json_object['path'],
        json_object['alias']
  end

  # Create targets from json_array
  def self.targets_from_json_array(json_array)
    json_array.collect do |target|
      from_json_object target
    end
  end
end
