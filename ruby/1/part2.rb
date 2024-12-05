if ARGV.length < 1
puts 'Give file name as argument'
  return
end
file_name = ARGV[0]
data = File.read(file_name).split
first = []
second = []
data.each_with_index do |data, i|
  i % 2 == 1 ? first << data.to_i : second << data.to_i
end
lookup = second.reduce({}) do |res, num| 
  res[num] = ((res[num] || 0) + 1) 
  res
end
puts first.reduce(0) { |sum, num| sum + num * (lookup[num] || 0) }
