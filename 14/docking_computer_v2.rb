class DockingComputerV2
  class Mask
    attr_reader :mask, :or_mask, :float_masks

    def set(mask)
      @mask = mask

      # The OR mask corresponds to all the ones.
      # It is what sets bits for us
      @or_mask = mask.gsub('X', '0').to_i(2)

      # The FLOAT mask corresponds to all the Xs.
      # This is gonna fluctuate!
      float_mask = mask.gsub('1', '0').gsub('X', '1').to_i(2)

      # Get the indices if each set bit in the mask
      indices = []
      i = 0
      until float_mask.zero?
        indices << i unless (float_mask & 0b1).zero?
        float_mask = (float_mask >> 1) & ~(1 << 36)
        i += 1
      end

      combinations = (0..indices.length).reduce(Enumerator::Chain.new) { |chain, i| chain += indices.combination(i) }

      # Convert our combinations back to masks
      @float_masks = []

      combinations.each do |comb|
        # The OR mask has bits set at the combination bits
        # The AND mask has bits unset at the bits NOT in the combination
        mask = {
          or: mask_from_set_bits(comb),
          and: ~mask_from_set_bits(indices - comb)
        }

        float_masks << mask
      end
    end

    # Return an array of all addresses to be set
    def apply(number)
      number = (number | or_mask)

      # Apply each float mask
      float_masks.map do |mask|
        (number | mask[:or]) & mask[:and]
      end
    end

    def mask_from_set_bits(set_bit_array)
      set_bit_array.reduce(0) { |acc, i| acc | 1 << i }
    end
  end

  attr_reader :memory, :mask

  def initialize
    @mask = Mask.new
    @memory = {}
  end

  def update_mask(new_mask)
    mask.set(new_mask)
  end

  def mem_write(addr, val)
    mask.apply(addr).each { |derived_addr| memory[derived_addr] = val }
  end
end
