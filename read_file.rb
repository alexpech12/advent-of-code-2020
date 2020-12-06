def read_file(filename)
  output = []
  File.foreach(filename) do |line|
    output << if block_given?
                yield(line)
              else
                line
              end
  end
  output
end

def read_file_groups(filename)
  output = []
  group = ''
  File.foreach(filename).with_index do |line, i|
    if line.chomp.empty? && i != 0
      output << if block_given?
                  yield(group)
                else
                  group
                end
      group = ''
    else
      group += line.chomp
    end
  end

  unless group.empty?
    output << if block_given?
      yield(group)
    else
      group
    end
  end

  output
end
