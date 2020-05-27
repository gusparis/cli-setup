# frozen_string_literal: true

require_relative 'setup_file'
require 'tty-font'

# SetupRunner is the piece that is used to execute rules.
# It provides to the user a step-by-step process.
class SetupRunner
  # Metadata about setup file
  # @param [SetupFile]
  def initialize(setup_file)
    @setup_file = setup_file
  end

  # Shows setup header data
  def setup_header
    font = TTY::Font.new(:doom)
    puts @setup_file.name unless @setup_file.meta.ascii_art
    puts font.write(@setup_file.meta.name) if @setup_file.meta.ascii_art
    puts @setup_file.meta.description
  end

  # Prepares rule execution
  def prepare
    @redo_requested = false
    @skip_requested = false
  end

  # Run
  def run
    setup_header
    @setup_file.rules.each do |rule|
      # Prepare rule
      prepare
      # Before hook
      execute_before rule
      next if @skip_requested

      # Execute rule, fake result
      result = 1
      yield rule, result if block_given?
      # After hook
      execute_after rule, result
      redo if @redo_requested
    end
  end

  # Hooks Executors
  def execute_after(rule, result)
    @after_rule&.call rule, result, lambda {
      @redo_requested = true
    }
  end

  def execute_before(rule)
    @before_rule&.call rule, lambda {
      @skip_requested = true
    }
  end

  # Hooks registers
  def before_rule(&block)
    @before_rule = block
  end

  def after_rule(&block)
    @after_rule = block
  end
end
