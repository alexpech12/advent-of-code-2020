class DockingComputer
  class Mask
    attr_reader :mask, :or_mask, :and_mask

    def set(mask)
      @mask = mask

      # The OR mask corresponds to all the ones.
      # It is what sets bits for us
      @or_mask = mask.gsub('X', '0').to_i(2)

      # The AND mask corresponds to all the zeros.
      # It is what unsets bits for us
      @and_mask = mask.gsub('X', '1').to_i(2)
    end

    def apply(number)
      (number | or_mask) & and_mask
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
    memory[addr] = mask.apply(val)
  end
end
