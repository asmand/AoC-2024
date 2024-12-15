if ARGV.length < 1
  puts 'Give file name as argument'
  return
end
file_name = ARGV[0]
lines = File.readlines(file_name, chomp:true).map(&:chars)
@height = lines.length
@width = lines[0].length

ats = {}

lines.each_with_index do |line, y|
  line.each_with_index do |c, x|
    ats[c] = (ats[c] || []) << [x,y] if c.match?(/[A-Za-z0-9]/)
  end
end

def find_antinodes_1(coord, coords) 
  res = coords.map do |other|
    dx = coord[0] - other[0]
    dy = coord[1] - other[1]
    nx = coord[0] + dx
    ny = coord[1] + dy
    next nil if out(nx, ny)
    [nx, ny]
  end
  res
end

def out(x, y)
  x < 0 || y < 0 || x >= @width || y >= @height
end

def find_antinodes_2(coord, coords) 
  res = coords.flat_map do |other|
    dx = coord[0] - other[0]
    dy = coord[1] - other[1]
    n = [[other[0], other[1]]]
    nx = coord[0]
    ny = coord[1]
    loop do
      nx = nx + dx
      ny = ny + dy
      break if out(nx, ny)
      n << [nx, ny] 
    end
    n
  end
  res
end


res_1 = ats.flat_map do |key, coords|
  coords.flat_map do |coord|
    find_antinodes_1(coord, coords - [coord]) 
  end
end

puts "with first rules: #{res_1.compact.uniq.length}"

res_2 = ats.flat_map do |key, coords|
  coords.flat_map do |coord|
    find_antinodes_2(coord, coords - [coord]) 
  end
end

puts "with second rules: #{res_2.compact.uniq.length}"
