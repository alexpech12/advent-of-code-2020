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
    REQUIRED_FIELDS.all? { |field| fields.keys.include? field }
  end
end

passports = [Passport.new]
read_file('input.txt') do |line|
  passports << Passport.new && next if line.chomp.empty?

  passports.last.parse_fields(line.chomp)
end


puts "#{passports.count(&:valid?)} out of #{passports.count} passports are valid"