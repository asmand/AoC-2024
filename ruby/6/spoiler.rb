# No good spoiler, just tried to speed things up at the cost of readability
# 
# The good new useful Ruby stuff was in the actual run, using Data.define for classish stuff

if ARGV.length < 1
  puts 'Give file name as argument'
  return
end
file_name = ARGV[0]
@initial_map = File.readlines(file_name, chomp:true).map { _1.split('') }
@height = @initial_map.length
@width = @initial_map[0].length

def initialize_current_map
  @current_map = []
  @initial_map.each { @current_map << _1.dup }
end

def directions
  %w(^ > v <)
end

def moves
  [[0, -1], [1, 0], [0, 1], [-1, 0]]
end

def tile_at(coordinate)
  @current_map[coordinate[1]][coordinate[0]]
end

def move_guard(guard)
  old_direction = guard[2]
  move = moves[directions.index(old_direction)]
  new_x = guard[0] + move[0]
  new_y = guard[1] + move[1]
  return nil if new_x < 0 || new_y < 0 || new_x >= @width || new_y >= @height

  if @current_map[new_y][new_x] == '#'
    new_direction = directions[(directions.index(old_direction) + 1) % directions.length]
    guard[2] = new_direction
  else
    guard[0] = new_x
    guard[1] = new_y
  end
  guard
end

def find_guard(map)
  directions.each_with_index do |guard, index|
    map.each_with_index do |row, y|
      x = row.index(guard)
      if x 
        return [x, y, directions[index]]
      end
    end
  end
end

def part_1(start_map)
  initialize_current_map()
  visited = []
  guard = find_guard(start_map)
  until guard.nil?
    visited.push(guard[0..1])
    guard = move_guard(guard)
  end
  puts ''
  puts "Guard is out"
  puts "The guard visited #{visited.uniq.length} locations"
  visited.uniq
end

def part_2(start_map, original_visited)
  start_guard = find_guard(start_map)
  original_visited.shift
  initialize_current_map()
  res = original_visited.sum do |obstacle|
    @current_map[obstacle[1]][obstacle[0]] = '#'
    guard = start_guard.dup
    visited = Set.new()
    loop_detected = false
    until guard.nil? || loop_detected
      loop_detected = visited.include? guard
      visited.add guard
      guard = move_guard(guard)
    end
    @current_map[obstacle[1]][obstacle[0]] = '.'
    loop_detected ? 1 : 0
  end
  puts ''
  puts "Found #{res} different loop positions"
end

guard_original_nodes = part_1(@initial_map)

part_2(@initial_map, guard_original_nodes)
