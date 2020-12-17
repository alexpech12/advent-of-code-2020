class PocketDimension
  class Cube
    attr_reader :active, :position

    def initialize(position, active)
      @position = position
      @active = active
    end

    def x
      position[0]
    end

    def y
      position[1]
    end

    def z
      position[2]
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

  attr_reader :grid, :active_cubes

  def initialize
    @grid = []
    @active_cubes = []
  end

  def fetch_cube(x, y, z)

    x += 1_000
    y += 1_000
    z += 1_000

    grid[x] = [] if grid[x].nil?
    grid[x][y] = [] if grid[x][y].nil?
    grid[x][y][z] = Cube.new([x - 1000, y - 1000, z - 1000], false) if grid[x][y][z].nil?

    grid[x][y][z]
  end

  # Returns the ranges required to be processed, based on the min/max positions of active cubes
  def processing_bounds
    minmax_x = active_cubes.map(&:x).minmax
    minmax_y = active_cubes.map(&:y).minmax
    minmax_z = active_cubes.map(&:z).minmax

    minmax_x[0] -= 1
    minmax_y[0] -= 1
    minmax_z[0] -= 1
    minmax_x[1] += 1
    minmax_y[1] += 1
    minmax_z[1] += 1
    [
      (minmax_x[0]..minmax_x[1]),
      (minmax_y[0]..minmax_y[1]),
      (minmax_z[0]..minmax_z[1])
    ]
  end

  def activate_cube!(x, y, z)
    fetch_cube(x, y, z).tap do |cube|
      break if cube.active?

      cube.activate!
      active_cubes << cube
    end
  end

  def deactivate_cube!(x, y, z)
    fetch_cube(x, y, z).tap do |cube|
      break if cube.inactive?

      cube.deactivate!
      @active_cubes -= [cube]
    end
  end

  def neighbouring_cubes(x, y, z)
    neighbours(x, y, z).map { |location| fetch_cube(*location) }
  end

  NEIGHBOUR_OFFSETS = [
    [-1,-1,-1],
    [-1,-1,0],
    [-1,-1,1],
    [-1,0,-1],
    [-1,0,0],
    [-1,0,1],
    [-1,1,-1],
    [-1,1,0],
    [-1,1,1],
    [0,-1,-1],
    [0,-1,0],
    [0,-1,1],
    [0,0,-1],
    [0,0,1],
    [0,1,-1],
    [0,1,0],
    [0,1,1],
    [1,-1,-1],
    [1,-1,0],
    [1,-1,1],
    [1,0,-1],
    [1,0,0],
    [1,0,1],
    [1,1,-1],
    [1,1,0],
    [1,1,1]
  ].freeze.each(&:freeze)

  def neighbours(x, y, z)
    origin = [x, y, z]
    NEIGHBOUR_OFFSETS.map { |offset| origin.map.with_index { |n, i| n + offset[i] } }
  end

  def print_to_display
    range_x, range_y, range_z = processing_bounds
    range_z.each do |z|
      puts "\nz=#{z}"
      range_y.each do |y|
        range_x.each do |x|
          cube = fetch_cube(x, y, z)

          if cube.active?
            print '#'
          else
            print '.'
          end
        end
        puts
      end
    end
  end
end
