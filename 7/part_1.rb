require_relative '../read_file.rb'
require 'set'

class BagRule
  class ContainingBagRule
    attr_reader :amount, :colour

    class << self
      def parse(str)
        ContainingBagRule.new(
          str.split(' ').first.to_i,
          str.split(' ')[1..2].join(' ')
        )
      end
    end

    def initialize(amount, colour)
      @amount = amount
      @colour = colour
    end
  end

  class << self
    def parse(str)
      bag_colour, containing_bag_strings = str.split(' bags contain ')
      containing_bags =
        containing_bag_strings.split(', ').map { |colour| ContainingBagRule.parse(colour) }

      BagRule.new(bag_colour, containing_bags)
    end
  end

  attr_reader :bag_colour, :containing_bags

  def initialize(bag_colour, containing_bags)
    @bag_colour = bag_colour
    @containing_bags = containing_bags
  end

  def containing_colours
    containing_bags.map(&:colour)
  end
end

# Map all the bag rules to their containing colours for easy rule lookup
containing_colour_map = {}

read_file('input.txt') do |line|
  rule = BagRule.parse(line)
  rule.containing_colours.each do |colour|
    if containing_colour_map.key? colour
      containing_colour_map[colour] << rule.bag_colour
    else
      containing_colour_map[colour] = [rule.bag_colour]
    end
  end
end

MY_BAG = 'shiny gold'.freeze

# 1. Find all rules that contain a 'shiny gold' bag
# 2. For each of those, follow the tree to the top, recording each bag colour
#
# To track these, we're going to handle a few different sets of colours
# Starting with the immediate bag colours that can contain shiny gold,
# we'll test each one and see if that colour can also be contained by other colours of bag.
# We'll add those to the remaining colours to be tested, and to prevent redoing work we've
# already done, we'll remove any of the colours already tested.

colours_for_my_bag = [].to_set
remaining_colours = containing_colour_map[MY_BAG].to_set

until remaining_colours.empty?
  # Add all the colours we're about to check into our list of colours for our bag.
  colours_for_my_bag += remaining_colours

  # Iterate through our remaining colours to check if they can be contained by another colour bag.
  # Add those results to our remaining colours to test
  remaining_colours.to_a.each do |colour|
    if containing_colour_map.key? colour
      remaining_colours += containing_colour_map[colour]
    end
  end
  # We don't want to test anything we've already done. Remove all current colours from the remaining.
  remaining_colours -= colours_for_my_bag
end

puts "There are #{colours_for_my_bag.count} different colours of bag that can contain #{MY_BAG}"