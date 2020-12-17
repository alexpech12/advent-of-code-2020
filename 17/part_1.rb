require_relative '../read_file.rb'
require_relative 'pocket_dimension.rb'

dimension = PocketDimension.new

location = [0,0,0]
read_file('input.txt') do |line|
  line = line.chomp
  location[0] = 0
  line.chars.each do |char|
    if char == '#'
      dimension.activate_cube!(*location)
    end
    location[0] += 1
  end
  location[1] += 1
end


puts "Active cube count #{dimension.active_cubes.count}"

dimension.print_to_display

(1..6).each do |i|
  puts "Starting cycle #{i}..."

  new_dimension = PocketDimension.new
  range_x, range_y, range_z = dimension.processing_bounds
  range_x.each do |x|
    range_y.each do |y|
      range_z.each do |z|
        cube = dimension.fetch_cube(x,y,z)
        neighbouring_cubes = dimension.neighbouring_cubes(x, y, z)
        if cube.active?
          if neighbouring_cubes.count(&:active?).between?(2, 3)
            new_dimension.activate_cube!(x,y,z)
          else
            new_dimension.deactivate_cube!(x,y,z)
          end
        else
          if neighbouring_cubes.count(&:active?) == 3
            new_dimension.activate_cube!(x,y,z)
          else
            new_dimension.deactivate_cube!(x,y,z)
          end
        end
      end
    end
  end

  dimension = new_dimension

  # dimension.print_to_display

  puts "Active cube count is now #{dimension.active_cubes.count}"

end