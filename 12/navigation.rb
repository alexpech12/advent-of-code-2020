class Navigation
  class Instruction
    class << self
      def parse(str)
        Instruction.new(
          command: str.chars[0].to_sym,
          amount: str.chomp[1..-1].to_i
        )
      end
    end

    COMMAND_TYPES = {
      cardinal: ->(s, dir, amt) { s.move_direction(dir, amt) },
      relative: ->(s, _dir, amt) { s.move_forward(amt) },
      rotate_right: ->(s, _dir, amt) { s.rotate(-amt) },
      rotate_left: ->(s, _dir, amt) { s.rotate(amt) },
    }

    COMMANDS = {
      N: COMMAND_TYPES[:cardinal],
      S: COMMAND_TYPES[:cardinal],
      E: COMMAND_TYPES[:cardinal],
      W: COMMAND_TYPES[:cardinal],
      L: COMMAND_TYPES[:rotate_left],
      R: COMMAND_TYPES[:rotate_right],
      F: COMMAND_TYPES[:relative]
    }

    NORTH = Vector[0,1]
    SOUTH = Vector[0,-1]
    EAST = Vector[1,0]
    WEST = Vector[-1,0]

    CARDINAL_DIRECTIONS = {
      N: NORTH,
      S: SOUTH,
      E: EAST,
      W: WEST
    }

    attr_reader :command, :amount

    def initialize(command:, amount:)
      @command = command
      @amount = amount
    end

    def execute(subject)
      COMMANDS[command].call(subject, CARDINAL_DIRECTIONS[command], amount)
    end

    def to_s
      "#{command}#{amount}"
    end
  end

  attr_reader :instructions, :ship

  def initialize(ship)
    @instructions = []
    @ship = ship
  end

  def parse_instruction(instruction_string)
    @instructions << Instruction.parse(instruction_string)
  end

  def execute_instructions!
    instructions.each do |i|
      i.execute(ship)
    end
  end
end
