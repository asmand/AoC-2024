if ARGV.length < 1
  puts 'Give file name as argument'
  return
end
file_name = ARGV[0]

rules = []
corrections = []
output = rules
File.readlines(file_name).each { _1.strip!; if _1 == '' then output = corrections else output << _1 end }
corrections = corrections.map { _1.split(',') }

@before_rules = {}
@after_rules = {}

rules.each do |rule|
  before, after = rule.split('|')
  @after_rules[after] = (@after_rules[after] || []) + [before]
  @before_rules[before] = (@before_rules[before] || []) + [after]
end

def valid_correction(pages)
  pages.map.with_index { |page, index| valid_page(pages, page, index)}.all?
end

def valid_page(pages, page, index)
  before = pages[...index]
  after = pages[index+1..-1]
  (((@before_rules[page] || []) & before).empty?) && (((@after_rules[page] || []) & after).empty?)
end

res = corrections.filter {|corr| valid_correction(corr) }.reduce(0) { |sum, corr| sum += corr[corr.length/2].to_i } 
puts "res is #{pp res}"
