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

def ops_1
  %i[+ *]
end

def ops_2
  %i[+ * con]
end

def find_sp1(sum, current, terms)
  ops_1.each do |op|
    if terms.empty?
      raise if current == sum
    else
      find_sp1(sum, current.send(op, terms[0]), terms[1..-1])
    end
  end
end

def find_sp2(sum, current, terms)
  ops_2.each do |op|
    if terms.empty?
      raise if current == sum
    else
      find_sp2(sum, current.send(op, terms[0]), terms[1..-1])
    end
  end
end

res = lines.sum do |line|
  sum, terms = line.split(':')
  sum = sum.to_i
  terms = terms.split(' ').map(&:to_i)
  begin
    find_sp1(sum, terms[0], terms[1..-1])
    0
  rescue 
    sum
  end
end

puts "with first set of operators: #{res}"

res2 = lines.sum do |line|
  sum, terms = line.split(':')
  sum = sum.to_i
  terms = terms.split(' ').map(&:to_i)
  begin
    find_sp2(sum, terms[0], terms[1..-1])
    0
  rescue 
    sum
  end
end

puts "with second set of operators: #{res2}"


