class BagRule
  class ContainingBagRule
    attr_reader :amount, :colour

    class << self
      def parse(str)
        return nil if str.to_i.zero?

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
    containing_bags&.map(&:colour)
  end

  def amount_of_contained_bags(bag_tree)
    return 0 if containing_bags.compact.empty?

    # Find children in the tree, and get amount for each child
    containing_bags.reduce(0) do |sum, bag|
      sum + bag.amount + bag.amount * bag_tree[bag.colour].amount_of_contained_bags(bag_tree)
    end
  end
end
