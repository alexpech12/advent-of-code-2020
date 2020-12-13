require_relative '../read_file.rb'
require_relative 'vector2.rb'

class Ship
  attr_reader :location, :forward_direction

  def initialize
    @location = Vector.zero(2)
    @forward_direction = Vector[1,0]
  end

  def move_direction(direction, distance)
    @location += direction * distance
  end

  def move_forward(distance)
    @location += forward_direction * distance
  end

  def rotate(angle)
    @forward_direction = forward_direction.rotate(angle)
  end
end

class ShipNavigation
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

ship = Ship.new
navigator = ShipNavigation.new(ship)

read_file('input.txt') do |line|
  navigator.parse_instruction(line.chomp)
end

navigator.execute_instructions!

puts "Final location is #{ship.location}"
puts "Manhattan distance = #{ship.location.map(&:abs).sum}"
