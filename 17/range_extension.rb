class Range
  def nested_map(nesting, *args)
    raise ArgumentError if nesting < 1

    map do |element|
      if nesting == 1
        args + [element]
      else
        nested_map(nesting - 1, *(args + [element]))
      end
    end
  end
end
