#!/usr/bin/env ruby

inputs = File.readlines("inputs/06.txt").map(&:chomp).map {|e| e.split(",")}.map {|e| [e[0].to_i, e[1].to_i]}

# inputs = [
#   [1, 1],
#   [1, 6],
#   [8, 3],
#   [3, 4],
#   [5, 5],
#   [8, 9]
# ]

max_grid_length = 1000

grid = Array.new(max_grid_length + 1) { Array.new(max_grid_length + 1) }
distances = Array.new(max_grid_length + 1) { Array.new(max_grid_length + 1) {max_grid_length} }

inputs.each_with_index do |location, index|
  point_x, point_y = location
  0.upto(max_grid_length).each do |x|
    0.upto(max_grid_length).each do |y|
      distance = (point_x - x).abs + (point_y - y).abs
      if distance < distances[y][x]
        distances[y][x] = distance
        grid[y][x] = index
      elsif distance == distances[y][x]
        grid[y][x] = "."
      end
    end
  end
end

candidates = (0...inputs.count).to_a
distance_record = {}


# delete all candidate on outer region of x axis
0.upto(max_grid_length) do |x|
  candidates.delete(grid[0][x])
  candidates.delete(grid[max_grid_length][x])
end

# delete all candidate on outer region of y axis
0.upto(max_grid_length) do |y|
  candidates.delete(grid[y][0])
  candidates.delete(grid[y][max_grid_length])
end

# add up area of remaining candidate
candidates.each do |candidate|
  0.upto(max_grid_length).each do |x|
    0.upto(max_grid_length).each do |y|
      elem = grid[y][x]
      if elem == candidate
        if distance_record[candidate]
          distance_record[candidate] += 1
        else
          distance_record[candidate] = 1
        end
      end
    end
  end
end

location, max_area = distance_record.max_by {|k, v| v}

puts "Location #{location} has max area: #{max_area}"

grid = Array.new(max_grid_length + 1) { Array.new(max_grid_length + 1) }

0.upto(max_grid_length).each do |x|
  0.upto(max_grid_length).each do |y|
    distance = 0
    inputs.each do |point_x, point_y|
      distance += (point_x - x).abs + (point_y - y).abs
    end
    if distance < 10_000
      grid[y][x] = "#"
    else
      grid[y][x] = "."
    end
  end
end

area = grid.flatten.count("#")

puts "The size of region: #{area}"
