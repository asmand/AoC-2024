# New (to me) Ruby functions
#
# each_cons - https://ruby-doc.org/core-2.7.2/Enumerable.html#method-i-each_cons
#
# Good reminder
#
# <=> the spaceship operator returns -1, 0, or 1 when comparing two numbers (lt eq gt)
#

if ARGV.length < 1
  puts 'Give file name as argument'
  return
end
file_name = ARGV[0]
reports = File.readlines(file_name).map { _1.split.map(&:to_i)}

def cp1(report)
  diffs = report.each_cons(2).map { _1 - _2 }
  [[-1],[1]].include?(diffs.map { _1 <=> 0 }.uniq) && diffs.all? { _1.abs <= 3 }
end

def cp2(report) 
  report.each_index.any? do
    copy = report.dup
    copy.delete_at(_1)
    cp1(copy)
  end
end

puts "number of safe reports: " + reports.count { cp1(_1) }.to_s

puts "number of dampened safe reports: " + reports.count { cp2(_1) }.to_s
