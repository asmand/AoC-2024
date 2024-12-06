# New (to me) Ruby functions
#
# transpose - https://ruby-doc.org/core-2.7.2/Array.html#method-i-transpose
# zip - https://ruby-doc.org/core-2.7.2/Enumerable.html#method-i-zip
# tally - https://ruby-doc.org/core-2.7.2/Enumerable.html#method-i-tally
#

if ARGV.length < 1
  puts 'Give file name as argument'
  return
end
file_name = ARGV[0]

data = File.open(file_name).map { _1.scan(/\d+/).map(&:to_i) }.transpose

puts "distance is: #{data[0].sort.zip(data[1].sort).sum { (_2 - _1).abs }}"

lookup = data[1].tally
puts "similarity is: #{data[0].sum do _1 * (lookup[_1] || 0) end}"

