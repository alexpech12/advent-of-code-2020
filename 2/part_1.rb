require_relative '../read_file.rb'
require_relative 'password_policy.rb'

result = read_file('input.txt') do |line|
  policy, password = line.split(': ')
  PasswordPolicy.parse(policy).valid_for_sled_rental_place_down_the_road?(password)
end.count(true)

puts "#{result} passwords are valid"
