#!/usr/bin/ruby

require_relative "computer_simulator"
require "test/unit"

class TestComputerSimulator < Test::Unit::TestCase

  def test_class
    # Verify that new instances can be created
    assert(Computer.new())
    assert(Computer.new(100))
    assert_instance_of(Computer, Computer.new())
  end

  # FIXME add tests for all methods
  
end
