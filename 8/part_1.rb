require_relative '../read_file.rb'
require_relative 'game_girl.rb'

boot_code = read_file('input.txt') do |line|
  GameGirl::Instruction.parse(line.chomp)
end

gg = GameGirl.new
gg.load_boot_code(boot_code)
begin
  gg.run_program
rescue GameGirl::InfiniteLoopDetected
  puts 'Detected infinite loop!'
end
puts "The accumulator value was #{gg.context.acc} before hitting the infinite loop"