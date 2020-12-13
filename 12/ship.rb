class Ship
  attr_reader :location, :forward_direction

  def initialize
    @location = Vector.zero(2)
    @forward_direction = Vector[1,0]
  end

  def move_direction(direction, distance)
    @location += direction * distance
  end

  def move_forward(distance)
    @location += forward_direction * distance
  end

  def rotate(angle)
    @forward_direction = forward_direction.rotate(angle)
  end
end
