if ARGV.length < 1
  puts 'Give file name as argument'
  return
end
file_name = ARGV[0]
lines = File.readlines(file_name, chomp:true)

def ops_1
  %i[+ *]
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

puts res
