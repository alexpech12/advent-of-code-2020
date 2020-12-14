require_relative 'ship.rb'

class WaypointShip < Ship
  attr_reader :waypoint

  def initialize
    super
    @waypoint = Vector[10, 1]
  end

  def move_direction(direction, distance)
    # Move the waypoint
    @waypoint += direction * distance
  end

  def move_forward(distance)
    # Move to the waypoint N times
    @location += waypoint * distance
  end

  def rotate(angle)
    # Rotate the waypoint around the ship
    @waypoint = waypoint.rotate(angle)
  end
end