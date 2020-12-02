class PasswordPolicy

  attr_reader :min, :max, :char

  class << self
    # Expects a string in the format "<min>-<max> <char>"
    def parse(str)
      range, char = str.split(' ')
      min, max = range.split('-')
      new(
        min: min.to_i,
        max: max.to_i,
        char: char
      )
    end
  end

  def initialize(min:, max:, char:)
    @min = min
    @max = max
    @char = char
  end

  def valid_for_sled_rental_place_down_the_road?(password)
    password.count(char).between?(min, max)
  end

  def valid_for_toboggan_corporate_policy?(password)
    (password[min - 1] == char) ^ (password[max - 1] == char)
  end
end