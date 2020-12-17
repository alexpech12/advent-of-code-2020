require_relative '../read_file.rb'
require_relative 'pocket_dimension.rb'

dimension_count = (ARGV[0] || 3).to_i
dimension = PocketDimension.new(dimension_count)

location = Array.new(dimension_count, 0)
read_file('input.txt') do |line|
  line = line.chomp
  location[0] = 0
  line.chars.each do |char|
    dimension.activate_cube!(location) if char == '#'
    location[0] += 1
  end
  location[1] += 1
end

dimension.print_to_display

(1..6).each do |i|
  puts "Starting cycle #{i}..."

  new_dimension = PocketDimension.new(dimension_count)

  dimension.each_in_bounds do |*position|
    cube = dimension.fetch_cube(position)
    neighbouring_cubes = dimension.neighbouring_cubes(position)
    if cube.active?
      if neighbouring_cubes.count(&:active?).between?(2, 3)
        new_dimension.activate_cube!(position)
      else
        new_dimension.deactivate_cube!(position)
      end
    else
      if neighbouring_cubes.count(&:active?) == 3
        new_dimension.activate_cube!(position)
      else
        new_dimension.deactivate_cube!(position)
      end
    end
  end

  dimension = new_dimension

  # dimension.print_to_display

  puts "Active cube count is now #{dimension.active_cubes.count}"
end