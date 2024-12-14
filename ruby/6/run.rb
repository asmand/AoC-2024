if ARGV.length < 1
  puts 'Give file name as argument'
  return
end
file_name = ARGV[0]
@initial_map = File.readlines(file_name, chomp:true).map { _1.split('') }

Coordinate = Data.define(:x, :y)
Guard = Data.define(:coord, :direction)

def initialize_current_map
  @current_map = []
  @initial_map.each { @current_map << _1.dup }
end

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

def part_1(start_map)
  initialize_current_map()
  visited = Set.new()
  guard = find_guard(start_map)
  until guard.nil?
    visited.add(guard.coord)
    print '.'
    guard = move_guard(guard)
  end
  puts ''
  puts "Guard is out"
  puts "The guard visited #{visited.length} locations"
  visited
end

def part_2(start_map, original_visited)
  guard = find_guard(start_map)
  original_visited.delete(guard.coord)
  res = original_visited.map do |obstacle|
    print '.'
    initialize_current_map()
    @current_map[obstacle.y][obstacle.x] = '#'
    guard = find_guard(start_map)
    visited = Set.new()
    loop_detected = false
    until guard.nil? || loop_detected
      loop_detected = visited.include? guard
      visited.add(guard)
      guard = move_guard(guard)
    end
    loop_detected || nil
  end.compact.count
  puts ''
  puts "Found #{res} different loop positions"
end

guard_original_nodes = part_1(@initial_map)

part_2(@initial_map, guard_original_nodes)
