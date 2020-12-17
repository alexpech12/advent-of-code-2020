require_relative 'array_extension.rb'
require_relative 'range_extension.rb'

class PocketDimension
  class Cube
    attr_reader :active, :position

    def initialize(position, active)
      @position = position
      @active = active
    end

    def activate!
      @active = true
    end

    def deactivate!
      @active = false
    end

    def active?
      active
    end

    def inactive?
      !active
    end
  end

  attr_reader :grid, :active_cubes, :dimensions, :neighbour_offsets

  def initialize(dimensions = 3)
    @grid = []
    @active_cubes = []
    @dimensions = dimensions
    @neighbour_offsets = (-1..1).nested_map(dimensions)
                                .flatten(dimensions - 1)
                                .-([Array.new(dimensions, 0)])
                                .freeze.each(&:freeze)
  end

  def fetch_cube(location)
    # This is a bit of a hack, but because our arrays can't use negative indices,
    # we'll just offset everything by some large number before we actually fetch/store things.
    safety_offset = 1_000
    abs_location = location.combine(Array.new(dimensions, safety_offset))

    grid_part = grid
    abs_location[0..-2].each do |i|
      next_part = grid_part[i]
      grid_part[i] = [] if next_part.nil?
      grid_part = grid_part[i]
    end

    grid_part[abs_location.last] = Cube.new(location.dup, false) if grid_part[abs_location.last].nil?
    grid_part[abs_location.last]
  end

  # Returns the ranges required to be processed, based on the min/max positions of active cubes
  def processing_bounds(buffer = [-1, 1])
    return nil if active_cubes.empty?

    minmaxes = (1..dimensions).map do |dimension|
      active_cubes.map do |cube|
        cube.position[dimension - 1]
      end.minmax.combine(buffer)
    end

    minmaxes.map(&:to_range)
  end

  def activate_cube!(location)
    fetch_cube(location).tap do |cube|
      break if cube.active?

      cube.activate!
      active_cubes << cube
    end
  end

  def deactivate_cube!(location)
    fetch_cube(location).tap do |cube|
      break if cube.inactive?

      cube.deactivate!
      @active_cubes -= [cube]
    end
  end

  def neighbouring_cubes(location)
    neighbours(location).map { |l| fetch_cube(l) }
  end

  def neighbours(location)
    neighbour_offsets.map { |offset| location.combine(offset) }
  end

  def each_in_bounds(bounds = processing_bounds, *args, &block)
    if bounds.count == 1
      bounds.first.each do |value|
        yield(*args, value)
      end
    else
      bounds.first.each do |value|
        remaining_bounds = bounds[1..-1]
        each_in_bounds(remaining_bounds, *(args + [value]), &block)
      end
    end
  end

  def print_to_display
    # Print in 2d slices
    bounds = processing_bounds([0, 0])
    range_x, range_y = bounds[0..1]
    extra_bounds = bounds[2..-1]

    each_in_bounds(extra_bounds) do |*values|
      values = [values] unless values.is_a? Array
      puts
      puts values.map.with_index { |v, i| "d#{i + 2}=#{v}" }.join(', ')
      range_y.each do |y|
        range_x.each do |x|
          cube = fetch_cube([x, y] + values)

          print(cube.active? ? '#' : '.')
        end
        puts
      end
    end
    puts
  end
end
