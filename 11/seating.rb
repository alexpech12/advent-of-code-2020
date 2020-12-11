class SeatingGrid
  class Seat
    TYPES = {
      '#' => :occupied,
      'L' => :empty,
      '.' => :floor
    }.freeze

    REVERSE_TYPES = {
      occupied: '#',
      empty: 'L',
      floor: '.'
    }.freeze

    class << self
      def parse(char)
        new(TYPES[char])
      end
    end

    attr_reader :type

    def initialize(type)
      @type = type
    end

    def dup
      Seat.new(type)
    end

    def ==(other)
      type == other.type
    end

    def occupied!
      @type = :occupied
      self
    end

    def occupied?
      type == :occupied
    end

    def empty!
      @type = :empty
      self
    end

    def empty?
      type == :empty
    end

    def floor?
      type == :floor
    end

    def to_s
      REVERSE_TYPES[type]
    end
  end

  attr_reader :rows

  def initialize
    @rows = []
  end

  def parse_row(row)
    rows << row.chars.map { |c| Seat.parse(c) }
  end

  def <<(row)
    rows << row
  end

  def diff_count(other_grid)
    rows.map.with_index do |row, i|
      other_row = other_grid.rows[i]
      row.zip(other_row).count { |a, b| a != b }
    end.sum
  end

  def people_do_things
    grid = SeatingGrid.new
    rows.each_with_index do |row, y|
      new_row = row.map.with_index do |s, x|
        if s.floor?
          s.dup
        elsif s.empty? && surrounding_seats(x, y).count(&:occupied?).zero?
          s.dup.occupied!
        elsif s.occupied? && surrounding_seats(x, y).count(&:occupied?) >= 4
          s.dup.empty!
        else
          s.dup
        end
      end
      grid << new_row
    end
    grid
  end

  def occupied_seats
    rows.flatten.select(&:occupied?)
  end

  def surrounding_seats(x, y)
    # Edges
    top, bottom, left, right = [y == 0, y == rows.length-1, x == 0, x == rows.first.length-1]
    seats = []
    # Start on the left and move around clockwise
    seats << seat(x - 1, y) unless left
    seats << seat(x - 1, y - 1) unless left || top
    seats << seat(x, y - 1) unless top
    seats << seat(x + 1, y - 1) unless right || top
    seats << seat(x + 1, y) unless right
    seats << seat(x + 1, y + 1) unless right || bottom
    seats << seat(x, y + 1) unless bottom
    seats << seat(x - 1, y + 1) unless left || bottom
    seats
  end

  def seat(x, y)
    rows[y][x]
  end

  def to_s
    rows.map do |row|
      row.map(&:to_s).join('')
    end.join("\n")
  end
end