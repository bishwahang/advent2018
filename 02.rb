#!/usr/bin/env ruby

input_list = File.readlines("inputs/02.txt").map(&:chomp)

# input_list = %w(
# abcde
# fghij
# klmno
# pqrst
# fguij
# axcye
# wvxyz
# )

thrice_count = 0
twice_count = 0

input_list.each do |id|
  chars = {}
  id.chars.each do |e|
    if chars[e]
      chars[e] += 1
    else
      chars[e] = 1
    end
  end

  twice_count += 1 if chars.values.include? 2
  thrice_count += 1 if chars.values.include? 3
end

puts "Answer 1: #{thrice_count * twice_count}"

# second part

input_list.each_with_index do |id, index|
  found = false
  current_id = id.chars

  input_list[index + 1..input_list.count - 1].each do |id2|
    compare_id = id2.chars

    next if compare_id == current_id

    diff_count = 0

    current_id.each_with_index do |char, idx|
      diff_count += 1 if char != compare_id[idx]

      break if diff_count > 1
    end

    if diff_count == 1
      puts "Answer 2: #{(current_id & compare_id).join}"
      found = true and break
    end
  end

  break if found
end
