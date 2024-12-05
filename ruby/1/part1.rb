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
first.sort!
second.sort!
puts first.each_with_index.reduce(0) { |sum, (num, i)| sum + (num - second[i]).abs }
