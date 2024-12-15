# Really ugly solution with the raise - rescue to break out when result was found. 
# Same solution as original run, just with one-liner for parsing the input.
if ARGV.length < 1
  puts 'Give file name as argument'
  return
end
file_name = ARGV[0]
lines = File.readlines(file_name).map { |line| [line.split(':')].flat_map { [_1.to_i, _2.split(' ').map(&:to_i)] } }

class Integer
  def con(n)
    (self.to_s + n.to_s).to_i
  end
end

def find_sp(ops, sum, current, terms)
  ops.each do |op|
    if terms.empty?
      raise if current == sum
    else
      find_sp(ops, sum, current.send(op, terms[0]), terms[1..-1])
    end
  end
end

def sum_operations(ops, lines)
  res = lines.sum do |line|
    begin
      find_sp(ops, line[0], line[1][0], line[1][1..-1])
      0
    rescue 
      line[0]
    end
  end
end

puts "with first set of operators: #{sum_operations(%i[+ *], lines)}"

puts "with second set of operators: #{sum_operations(%i[+ * con], lines)}"


