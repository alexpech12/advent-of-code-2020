require_relative '../read_file'

class Passport
  attr_accessor :fields

  REQUIRED_FIELDS = %w[byr iyr eyr hgt hcl ecl pid]
  OPTIONAL_FIELDS = %w[cid]

  def initialize
    @fields = {}
  end

  def parse_fields(input)
    input.split(' ').each do |kvp|
      key, value = kvp.split(':')
      fields[key] = value
    end
  end

  def valid?
    fields_required? && fields.all?(&method(:field_valid?))
  end

  def fields_required?
    REQUIRED_FIELDS.all? { |field| fields.keys.include? field }
  end

  def field_valid?(field)
    key, value = field
    case key
    when 'byr'
      value.to_i.between?(1920, 2002)
    when 'iyr'
      value.to_i.between?(2010, 2020)
    when 'eyr'
      value.to_i.between?(2020, 2030)
    when 'hgt'
      value.length >= 4 &&
        (value[-2..-1] == 'cm' && value.to_i.between?(150, 193) ||
        value[-2..-1] == 'in' && value.to_i.between?(59, 76))
    when 'hcl'
      value.length == 7 &&
        value[0] == '#' &&
        value[1..-1].split('').all? { |c| (('0'..'9').to_a + ('a'..'f').to_a).include? c }
    when 'ecl'
      %w[amb blu brn gry grn hzl oth].include? value
    when 'pid'
      value.length == 9 && value.to_i.to_s.rjust(9, '0') == value
    when 'cid'
      true
    else
      false
    end
  end
end

passports = [Passport.new]
read_file('input.txt') do |line|
  passports << Passport.new && next if line.chomp.empty?

  passports.last.parse_fields(line.chomp)
end

puts "#{passports.count(&:valid?)} out of #{passports.count} passports are valid"