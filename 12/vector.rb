require 'matrix'

class Vector
  def x
    self[0]
  end

  def y
    self[1]
  end

  def rotate(angle_degrees)
    raise RuntimeError unless size == 2

    angle_radians = angle_degrees * Math::PI / 180

    sin_a = Math.sin(angle_radians).round(10)
    cos_a = Math.cos(angle_radians).round(10)
    Vector[
      x * cos_a - y * sin_a,
      x * sin_a + y * cos_a
    ]
  end
end
