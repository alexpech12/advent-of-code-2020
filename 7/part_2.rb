require_relative '../read_file.rb'
require_relative 'bag_rules.rb'
require 'set'

# Map all the bag rules to their colours for easy rule lookup
bag_colour_map = {}

read_file('input.txt') do |line|
  BagRule.parse(line).tap { |rule| bag_colour_map[rule.bag_colour] = rule }
end

MY_BAG = 'shiny gold'.freeze

puts "My #{MY_BAG} bag needs to contain #{bag_colour_map[MY_BAG].amount_of_contained_bags(bag_colour_map)} other bags"
