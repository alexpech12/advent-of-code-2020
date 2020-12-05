class BoardingPass
  class Parser
    attr_reader :number

    SEAT_TO_BIN_MAP = {
      'F' => '0',
      'B' => '1',
      'L' => '0',
      'R' => '1'
    }

    def initialize(code)
      @number = code.chars.map { |c| SEAT_TO_BIN_MAP[c] }.join.to_i(2)
    end
  end

  def initialize(seating_code)
    @row_parser = Parser.new(seating_code[0..6])
    @column_parser = Parser.new(seating_code[7..9])
  end

  def seat_number
    8 * row_number + column_number
  end

  attr_reader :row_parser, :column_parser

  private

  def row_number
    row_parser.number
  end

  def column_number
    column_parser.number
  end
end
