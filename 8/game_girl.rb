DEBUG = false

def puts_debug(str)
  puts str if DEBUG
end

class GameGirl
  class Instruction
    class << self
      def parse(str)
        op, arg = str.split(' ')
        {
          nop: NoopInstruction,
          jmp: JumpInstruction,
          acc: AccInstruction
        }[op.to_sym].new(arg.to_i)
      end
    end

    attr_reader :argument, :exec_count

    def initialize(argument)
      @argument = argument
      @exec_count = 0
    end

    def execute(_context)
      puts_debug "Executing #{self.class} #{argument} (Exec count is #{exec_count})"
      @exec_count += 1
    end

    def reset_exec_count
      @exec_count = 0
    end
  end

  class NoopInstruction < Instruction; end

  class JumpInstruction < Instruction
    def execute(context)
      super
      context.offset_program_counter(argument)
    end
  end

  class AccInstruction < Instruction
    def execute(context)
      super
      context.accumulate(argument)
    end
  end

  class Context
    attr_reader :pct, :acc

    def initialize
      @pct = 0
      @acc = 0
    end

    def step
      @pct += 1
    end

    def offset_program_counter(offset)
      puts_debug "Updating program counter from #{@pct} to #{@pct + offset - 1}"
      @pct += offset - 1
    end

    def accumulate(value)
      puts_debug "Updating accumulator counter from #{@acc} to #{@acc + value}"
      @acc += value
    end
  end

  class InfiniteLoopDetected < RuntimeError
    attr_reader :execution_log

    def initialize(execution_log)
      @execution_log = execution_log
    end
  end

  attr_reader :context, :instructions

  def initialize
    @context = Context.new
  end

  def load_boot_code(boot_code)
    @instructions = boot_code
  end

  def reset
    @context = Context.new
    instructions.each(&:reset_exec_count)
  end

  def run_program
    execution_log = []
    until terminated?
      raise InfiniteLoopDetected.new(execution_log), 'Ho ho HO NO!' if infinite_loop_detected?

      execution_log << { pct: context.pct, instruction: next_instruction }
      run_step
    end
  end

  def run_step
    puts_debug "Next instruction is #{next_instruction.class}, #{next_instruction.argument}..."
    next_instruction.execute(context)
    context.step
  end

  def terminated?
    next_instruction.nil?
  end

  def infinite_loop_detected?
    next_instruction.exec_count != 0
  end

  def next_instruction
    instructions[context.pct]
  end

  def patch_instruction(pct:, instruction:)
    instructions[pct] = instruction
  end
end
