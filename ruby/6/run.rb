if ARGV.length < 1
  puts 'Give file name as argument'
  return
end
file_name = ARGV[0]
initial_map = File.readlines(file_name, chomp:true).map { _1.split('') }

# pp initial_map

@current_map = []
initial_map.each { @current_map << _1 }

# puts @current_map

Coordinate = Data.define(:x, :y)
Guard = Data.define(:coord, :direction)

@visited = Set.new()

def guards 
  ['^', '>', 'v', '<']
end

def directions
  %i[n e s w]
end

def tile_at(coordinate)
  @current_map[coordinate.y][coordinate.x]
end

def move_guard(guard)
  old_coord = guard.coord
  @visited.add(old_coord)
  old_direction = guard.direction
  @current_map[old_coord.y][old_coord.x] = '.'
  case guard.direction
  when :n
    new_point = Coordinate.new(old_coord.x, old_coord.y - 1)
  when :e
    new_point = Coordinate.new(old_coord.x + 1, old_coord.y)
  when :s
    new_point = Coordinate.new(old_coord.x, old_coord.y + 1)
  when :w
    new_point = Coordinate.new(old_coord.x - 1, old_coord.y)
  end
  return nil if new_point.x < 0 || new_point.y < 0 || new_point.y >= @current_map.length || new_point.x >= @current_map[new_point.y].length

  if tile_at(new_point) == '#'
    new_direction = directions[(directions.index(old_direction) + 1) % directions.length]
    new_guard = Guard.new(old_coord, new_direction)
  else
    old_direction
    new_guard = Guard.new(new_point, old_direction)
  end

  
  @current_map[new_guard.coord.y][new_guard.coord.x] = guards[directions.index(new_guard.direction)]
  new_guard
end

def draw_map
  pp @current_map
end

def find_guard(map)
  guards.each_with_index do |guard, index|
    map.each_with_index do |row, y|
      x = row.index(guard)
      if x 
        return Guard.new(Coordinate.new(x, y), directions[index])
      end
    end
  end
end

guard = find_guard(initial_map)
until guard.nil?
  # draw_map
  # sleep(0.1)
  print '.'
  guard = move_guard(guard)
end
# draw_map
puts "Guard is out"
pp @visited
pp @visited.length
