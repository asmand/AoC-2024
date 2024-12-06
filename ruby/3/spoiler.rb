# New (to me) Ruby concepts
#
# case..in - I only knew about case..when
#

if ARGV.length < 1
  puts 'Give file name as argument'
  return
end
file_name = ARGV[0]

input = File.read(file_name)

def part_1(data)
  data.scan(/mul\((\d+),(\d+)\)/).sum { _1[0].to_i * _1[1].to_i }
end

def part_2(data)
  match = data.scan(/(don't)|(do)|mul\((\d+),(\d+)\)/).map(&:compact)
  match.reduce([0, true]) do |(sum, enabled), op|
    case op
    in ["don't"] then [sum, false]
    in ["do"] then [sum, true]
    in [a, b] then [sum + ((enabled && a.to_i * b.to_i) || 0), enabled]
    end
  end.first
end

puts "sum without do-don't is #{part_1(input)}"

puts "sum with do-don't is #{part_2(input)}"
