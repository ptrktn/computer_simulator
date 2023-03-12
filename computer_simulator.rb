#!/usr/bin/ruby
# My First Ruby application

# Constants given in the assignment
MAIN_BEGIN = 0
PRINT_TENTEN_BEGIN = 50

# Verbose debug output for development
def dbg(msg)
  if "1" == ENV["DEBUG"]
    print("DEBUG #{msg}\n")
  end
end

# Computer simulator class
class Computer
  # Constructor 
  def initialize(stack_size=100)
    # Stack is an instance variable
    @stack = []
    (0..stack_size-1).each do |i|
      @stack.push(nil)
    end

    # Program Counter
    @pc = 0
    # Stack Pointer
    @sp = stack_size - 20   # FIXME check limits
  end

  # Set the Program Counter
  def set_address(addr=0)
    # FIXME check for the correct address range
    @pc = addr
    return self
  end

  # Insert instructions and their arguments to the stack and strings.
  def insert(arg1, arg2=nil)
    # FIXME there must be a better way to handle variable argument list
    if arg2
      @stack[@pc] = arg1.to_s + " " + arg2.to_s
    else
      @stack[@pc] = arg1.to_s
    end
    @pc = @pc + 1
    return self
  end

  # Execute the instructions in the stack
  # `MULT`: Pop the 2 arguments from the stack, multiply them and push the
  #         result back to the stack
  # `CALL addr`: Set the program counter (PC) to `addr`
  # `RET`: Pop address from stack and set PC to address
  # `STOP`: Exit the program
  # `PRINT`: Pop value from stack and print it
  # `PUSH arg`: Push argument to the stack
  def execute(addr=0)
    @pc = addr

    # FIXME check for stack under/overflow in each push/pop
    # One can not execute the stack beyond its length
    while @pc < @stack.length()

      # Get out if undefined instructions are found
      #unless @stack[@pc]
      #  break
      #end
      
      args = @stack[@pc].split()

      if args.length() < 2
        # An instruction without an argument
        instr = args[0]
        arg = nil
      else
        # An instruction + argument
        # Assume the argument is always an integer
        instr = args[0]
        arg = args[1].to_i
      end

      dbg("I #{instr} A #{arg}")

      if "STOP" == instr
      # Stop the execution
        break
      elsif "PUSH" == instr
        # Push the argument to the stack
        @sp = @sp + 1
        @stack[@sp] = arg        
      elsif "PRINT" == instr
        # Pop value from stack and print it
        value = @stack[@sp]
        @sp = @sp - 1
        print("#{value}\n")
      elsif "CALL" == instr
      # Set the Program Counter
        @pc = arg
      elsif "RET" == instr
        # Pop value from the stack and set PC 
        @pc = @stack[@sp]
        @sp = @sp - 1
      elsif "MULT" == instr
      # Pop the 2 arguments from the stack, multiply them and push the
      # result back to the stack
        value1 = @stack[@sp]
        @sp = @sp - 1
        value2 = @stack[@sp]
        # Push the result to the stack
        @stack[@sp] = value1 * value2
      else
        print("ERROR: undefined instruction #{instr}\n")
        break
      end

      unless ["CALL", "RET"].include? instr
        @pc = @pc + 1
      end
      
    end

  end
  
  def print_stack()
    dbg("PC = #{@pc} SP = #{@sp}")
    i = 0
    @stack.each do |j|
      dbg("#{i} #{j}")
      i = i + 1
    end
  end
  
end


def main  
  # Create new computer with a stack of 100 addresses
  computer = Computer.new(100)
  
  # Instructions for the print_tenten function
  computer.set_address(PRINT_TENTEN_BEGIN).insert("MULT").insert("PRINT").insert("RET")

  # The start of the main function
  computer.set_address(MAIN_BEGIN).insert("PUSH", 1009).insert("PRINT")

  # Return address for when print_tenten function finishes
  computer.insert("PUSH", 6)
  # Setup arguments and call print_tenten
  computer.insert("PUSH", 101).insert("PUSH", 10).insert("CALL", PRINT_TENTEN_BEGIN)

  # Stop the program
  computer.insert("STOP")

  # Execute the stack
  computer.set_address(MAIN_BEGIN).execute()

  # Print stack only in debug mode
  if "1" == ENV["DEBUG"]
    computer.print_stack()
  end

end

main()
