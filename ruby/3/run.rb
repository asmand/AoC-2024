if ARGV.length < 1
  puts 'Give file name as argument'
  return
end
file_name = ARGV[0]

input = File.read(file_name)

sum = input.scan(/mul\((\d+),(\d+)\)/).sum { _1[0].to_i * _1[1].to_i }

def part_2(data)
  match = data.scan(/(don't)|(do)|mul\((\d+),(\d+)\)/).map(&:compact)
  d = true
  res = match.map do |op|
    case 
    when op.length == 1 && d && op[0] == "don't"
      d = false
      nil
    when op.length == 1 && !d && op[0] == "do"
      d = true
      nil
    when op.length == 2 && d
      op[0].to_i * op[1].to_i
    end
  end.compact.sum
end

puts "sum without do-don't is #{sum}"

puts "sum with do-don't is #{part_2(input)}"
