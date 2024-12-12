# Good reminder
#
# array.index with a block, returns the first index where the block returns a truthy value
#
# You can create a Hash with a default value if the key is not defined. https://ruby-doc.org/core-2.5.8/Hash.html#method-c-new
#
# Set makes sure that there are no duplicates. https://ruby-doc.org/stdlib-2.7.1/libdoc/set/rdoc/Set.html
#
# Since we always verify the entire correction from the beginning, there is no need for the "validate before"
#

if ARGV.length < 1
  puts 'Give file name as argument'
  return
end
file_name = ARGV[0]

rules, corrections = File.read(file_name).split("\n\n").map { _1.lines.map { |line| line.scan(/\d+/).map(&:to_i) } }

@after_rules = Hash.new { _1[_2] = Set[] }
rules.each { @after_rules[_2] << _1 }

def valid_correction(pages)
  pages.map.with_index { |page, index| (@after_rules[page] & pages[index+1..-1]).empty? }.all?
end

def sort_correction(pages)
  sorted = []
  pages.each do |page|
    new_index = sorted.index { @after_rules[page].include?(_1) } || -1
    sorted.insert(new_index, page)
  end
  sorted
end

res = corrections.sum { valid_correction(_1) ? _1[_1.length/2] : 0 }
puts "Sum of valid middle pages is #{res}"

res = corrections.sum { valid_correction(_1) ? 0 : sort_correction(_1)[_1.length / 2] }
puts "Sum of corrected middle pages is #{res}"
