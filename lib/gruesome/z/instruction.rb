module Gruesome
  module Z

    # A Z-Machine instruction
    class Instruction
      attr_reader :opcode      # the opcode
      attr_reader :types      # the types of the operands
      attr_reader :operands    # the operands given to the instruction
      attr_reader :destination  # the destination variable to place the result
      attr_reader :branch_to    # the address to set the pc when branch is taken 
                    #  also... if 0, return true from routine
                    #          if 1, return false from routine
      attr_reader :branch_on    # the condition is matched against this
      attr_reader :length      # instruction size in number of bytes

      def initialize(opcode, types, operands, destination, branch_destination, branch_condition, length)
        @opcode = opcode
        @types = types
        @operands = operands
        @destination = destination
        @branch_to = branch_destination
        @branch_on = branch_condition
        @length = length
      end

      def to_s(version)
        line = Opcode.name(@opcode, version)
        idx = -1
        line = line + @operands.inject("") do |result, element|
          idx += 1
          if @types[idx] == OperandType::VARIABLE
            result + " %" + sprintf("%02x", element)
          else
            result + " " + element.to_s
          end
        end

        if @destination != nil
          line = line + " -> %" + sprintf("%02x", @destination)
        end

        if @branch_to != nil
          line = line + " goto $" + sprintf("%04x", @branch_to) + " on " + @branch_on.to_s
        end

        line
      end
    end
  end
end
