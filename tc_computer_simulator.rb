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

  def test_stack_overflow
    computer = Computer.new(100)
    (0..30).each do |i|
      computer.insert("PUSH", i)
    end
    computer.insert("STOP")
    computer.execute()
    computer.print_stack()
  end
    
  # FIXME add tests for all methods
  
end
