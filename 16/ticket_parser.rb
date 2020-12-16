class Ticket
  attr_reader :fields

  def initialize(fields)
    @fields = fields
  end
end

class TicketParser
  attr_reader :tickets

  def initialize
    @tickets = []
  end

  def parse(input)
    tickets << Ticket.new(input.split(',').map(&:to_i))
  end
end
