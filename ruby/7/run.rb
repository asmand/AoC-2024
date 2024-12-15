if ARGV.length < 1
  puts 'Give file name as argument'
  return
end
file_name = ARGV[0]
lines = File.readlines(file_name, chomp:true)

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
    sum, terms = line.split(':')
    sum = sum.to_i
    terms = terms.split(' ').map(&:to_i)
    begin
      find_sp(ops, sum, terms[0], terms[1..-1])
      0
    rescue 
      sum
    end
  end
end

puts "with first set of operators: #{sum_operations(%i[+ *], lines)}"

puts "with second set of operators: #{sum_operations(%i[+ * con], lines)}"


