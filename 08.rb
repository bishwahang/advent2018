#!/usr/bin/env ruby

input = File.readlines("inputs/08.txt").map(&:chomp).map(&:strip).first.split.map(&:to_i)

# input = "2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2".split.map(&:to_i)

class Node
  attr_reader :id, :child_number, :metadata_number
  attr_reader :childs, :metadata
  attr_accessor :value
  def initialize(id, child_number, metadata_number)
    @id              = id
    @child_number    = child_number
    @metadata_number = metadata_number
    @childs          = []
    @metadata        = []
  end

  def ==(other)
    self.value == other.value
  end

  def to_s
    "#{value} - #{childs.count}"
  end
end

child_number = input[0]
metadata_number = input[1]
root_node = Node.new(0, child_number, metadata_number)

nodes_to_traverse = [root_node]
nodes = [root_node]

# starting index after creating the root node

flag = 2
while !nodes_to_traverse.empty? do
  node = nodes_to_traverse.last
  if node.childs.count == node.child_number
    (flag...(flag + node.metadata_number)).each do |index|
      node.metadata << input[index]
    end
    flag += node.metadata_number
    nodes_to_traverse.pop
  else
    child_number = input[flag]
    metadata_number = input[flag + 1]
    new_node = Node.new(flag, child_number, metadata_number)

    node.childs << new_node
    nodes_to_traverse << new_node

    flag += 2
    nodes << new_node
  end
end

sum = root_node.metadata.inject(:+)

childs_to_visit = root_node.childs.dup

while !childs_to_visit.empty? do
  child = childs_to_visit.pop
  sum += child.metadata.inject(:+)
  childs_to_visit += child.childs
  childs_to_visit.flatten
end

puts "Sum of metadata entries: #{sum}"

nodes.reverse.each do |n|
  if n.metadata.empty?
    n.value = 0
  elsif n.childs.empty?
    n.value = n.metadata.inject(:+)
  else
    sum = 0
    n.metadata.each do |reference|
      reference -= 1
      next if reference < 0
      next if n.childs[reference].nil?
      sum += n.childs[reference].value
    end
    n.value = sum
  end
end

puts "Value of root node: #{root_node.value}"
