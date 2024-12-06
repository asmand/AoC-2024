if ARGV.length < 1
  puts 'Give file name as argument'
  return
end
file_name = ARGV[0]
reports = File.readlines(file_name).map { _1.split.map(&:to_i)}

def deep_clone(arr)
  arr.clone.map(&:clone)
end

first_run = deep_clone(reports)

def cp1(first, rest, dir = nil) 
  n = rest.shift
  return true if n.nil?
  return cp1(n, rest, 1) if first < n && (dir.nil? || dir > 0) && n - first <= 3 
  return cp1(n, rest, -1) if first > n && (dir.nil? || dir < 0) && first -n <= 3
  false
end

def cp2(handled, first, rest, dir)
  n = rest.shift
  return true if n.nil?
  return cp2(handled << first, n, rest, 1) if first < n && (dir.nil? || dir > 0) && n - first <= 3 
  return cp2(handled << first, n, rest, -1) if first > n && (dir.nil? || dir < 0) && first -n <= 3
  current_gone = deep_clone(handled) + [n] + deep_clone(rest)
  next_gone = deep_clone(handled) + [first] + deep_clone(rest)
  if handled.length > 0
    previous_gone = deep_clone(handled[0...-1]) + [first] + [n] + deep_clone(rest)
  else
    previous_gone = deep_clone(current_gone)
  end
  return cp1(current_gone.shift, current_gone, nil) || cp1(next_gone.shift, next_gone, nil) || cp1(previous_gone.shift, previous_gone, nil)
  false
end

puts "number of reports: " + first_run.filter { cp1(_1.shift, _1) }.count.to_s

puts "number of reports, with damper: " + reports.filter { cp2([], _1.shift, _1, nil) }.count.to_s
