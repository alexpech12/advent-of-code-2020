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
