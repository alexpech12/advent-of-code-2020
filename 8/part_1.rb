require_relative '../read_file.rb'
require_relative 'game_girl.rb'

boot_code = read_file('input.txt') do |line|
  GameGirl::Instruction.parse(line.chomp)
end

gg = GameGirl.new
gg.load_boot_code(boot_code)
gg.run_until_infinite_loop
puts "The accumulator value was #{gg.context.acc} before hitting the infinite loop"