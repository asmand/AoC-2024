if ARGV.length < 1
  puts 'Give file name as argument'
  return
end
file_name = ARGV[0]

@input = File.readlines(file_name, chomp:true)

def n(x, y)
  [x, y-1, y-1 < 0 ? 'Q' : @input[y-1][x]]
end

def s(x, y)
  [x, y+1, y+1 >= @input.length ? 'Q' : @input[y+1][x]]
end

def e(x, y)
  [x+1, y, x+1 >= @input[y].length ? 'Q' : @input[y][x+1]]
end

def w(x, y)
  [x-1, y, x-1 < 0 ? 'Q' : @input[y][x-1]]
end

def diag(x, y, first, second)
  a = self.send(first, x, y)
  return a if a[2] == 'Q'
  b = self.send(second, a[0], a[1])
  [b[0], b[1], b[2] == 'Q' ? 'Q' : @input[b[1]][b[0]]]
end

def nw(x, y)
  diag(x, y, :n, :w)
end

def ne(x, y)
  diag(x, y, :n, :e)
end

def sw(x, y)
  diag(x, y, :s, :w)
end

def se(x, y)
  diag(x, y, :s, :e)
end

def search(x, y, dir, chars)
  if @input[y][x] == chars[0]
    return true if chars.length == 1
    f = self.send(dir, x, y)
    return false if f[2] == 'Q'
    search(f[0], f[1], dir, chars[1..-1])
  else
    return false
  end
end

found = 0
@input.each_with_index do |row, i|
  row.chars.each_with_index do |char, j|
    %i[n s e w nw ne se sw].each do |dir|
      if search(j, i, dir, %w[X M A S])
        found += 1
      end
    end
  end
end

puts "found #{found} instances of XMAS"

found_mas = []
@input.each_with_index do |row, i|
  row.chars.each_with_index do |char, j|
    %i[nw ne sw se].each do |dir|
      if search(j, i, dir, %w[M A S])
        found_mas << [j, i, dir]
      end
    end
  end
end

res = found_mas.map { |mas| self.send(mas[2], mas[0], mas[1])[0..1] }.group_by { _1 }.select { _2.length == 2 }.count

puts "found #{res} instances of X-MAS"
