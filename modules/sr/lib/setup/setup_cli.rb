# frozen_string_literal: true

require_relative 'setup_file'
require 'tty-prompt'
$verbose = true

begin
  setup_file = SetupFile.from_file! '../setup-file.json'
rescue SetupFile::MissingSetupFileError => e
  puts 'Missing setup file. Please check your current working directory.'
rescue SetupFile::InvalidSetupFileError => e
  puts 'Invalid schema. Please check your setup file.'
ensure
  TTY::Prompt.new.error e.to_s
end
