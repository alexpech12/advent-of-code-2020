class TicketValidator
  class << self
    def find_all_invalid_values(tickets, rules)
      tickets.map(&:fields).flatten.select do |field|
        rules.none? { |rule| rule.valid?(field) }
      end
    end
  end
end
