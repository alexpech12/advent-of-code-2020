require_relative '../read_file.rb'
require_relative 'game_girl.rb'

class GameGirlRunner
  attr_reader :game_girl

  def run_debug_program
    @game_girl = GameGirl.new

    load_boot_code

    begin
      game_girl.run_program
    rescue GameGirl::InfiniteLoopDetected => e
      puts 'Attempting to recover from infinite loop...'
      e.execution_log.each do |log|
        if patch_and_test(log)
          puts 'Patch was successful!'
          puts "Patched instruction was #{log}"
          break
        else
          print 'x'
        end
      end
    end

    puts "The accumulator value was #{game_girl.context.acc} after completing boot program"
  end

  def load_boot_code
    boot_code = read_file('input.txt') do |line|
      GameGirl::Instruction.parse(line.chomp)
    end

    game_girl.load_boot_code(boot_code)
  end

  def patch_and_test(log)
    new_instruction = get_patched_instruction(log[:instruction])
    return false if new_instruction.nil?

    game_girl.patch_instruction(pct: log[:pct], instruction: new_instruction)
    game_girl.reset
    begin
      game_girl.run_program
      return true
    rescue GameGirl::InfiniteLoopDetected
      # Undo patch
      game_girl.patch_instruction(**log)
      return false
    end
  end

  def get_patched_instruction(instruction)
    if instruction.is_a? GameGirl::JumpInstruction
      GameGirl::NoopInstruction.new(instruction.argument)
    elsif instruction.is_a? GameGirl::NoopInstruction
      GameGirl::JumpInstruction.new(instruction.argument)
    else
      nil
    end
  end
end

GameGirlRunner.new.run_debug_program
