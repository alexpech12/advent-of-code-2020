class TicketValidator
  class << self
    def find_all_invalid_values(tickets, rules)
      tickets.map(&:fields).flatten.select do |field|
        rules.none? { |rule| rule.valid?(field) }
      end
    end

    def select_valid_tickets(tickets, rules)
      tickets.select do |ticket|
        all_ticket_fields_valid?(ticket, rules)
      end
    end

    def all_ticket_fields_valid?(ticket, rules)
      ticket.fields.all? { |field| field_valid_for_any_rule?(field, rules) }
    end

    def field_valid_for_any_rule?(field, rules)
      rules.any? { |rule| rule.valid?(field) }
    end

    def valid_rules_for_field(tickets, rules, field_index)
      fields = tickets.map { |t| t.fields[field_index] }
      rules.select { |rule| fields.all? { |field| rule.valid?(field) } }
    end
  end
end
