#!/usr/bin/env ruby

input_list = File.readlines("inputs/01.txt").map(&:chomp).map(&:to_i)

# input_list = [+7, +7, -2, -7, -4]

current_frequency = 0
visited_frequency = [current_frequency]

found = false
round = 0

loop do
  round += 1
  input_list.each do |elem|
    current_frequency += elem
    if visited_frequency.include? current_frequency
      found = true and break
    end
    visited_frequency << current_frequency
  end
  break if found
end

puts "Round: #{round}"
puts "Repeated frequency: #{current_frequency}"
