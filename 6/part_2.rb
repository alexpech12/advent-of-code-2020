require_relative '../read_file.rb'

class CustomsGroup
  attr_accessor :group_response

  def initialize
    @group_response = nil
  end

  def add_response(response)
    @group_response =
      if group_response.nil?
        # New group
        response
      else
        string_intersect(group_response, response)
      end
  end

  private

  def string_intersect(str1, str2)
    (str1.split('') & str2.split('')).join('')
  end
end

groups = [CustomsGroup.new]
read_file('input.txt') do |line|
  if line.chomp.empty?
    groups << CustomsGroup.new
  else
    groups.last.add_response(line.chomp)
  end
end

group_sum = groups.map(&:group_response).map(&:length).sum

puts "Final result is #{group_sum}"
