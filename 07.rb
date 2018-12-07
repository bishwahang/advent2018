#!/usr/bin/env ruby
inputs = File.readlines("inputs/07.txt").map(&:chomp)

# test_input =<<~TEST
# Step C must be finished before step A can begin.
# Step C must be finished before step F can begin.
# Step A must be finished before step B can begin.
# Step A must be finished before step D can begin.
# Step B must be finished before step E can begin.
# Step D must be finished before step E can begin.
# Step F must be finished before step E can begin.
# TEST

# inputs = test_input.split("\n").map(&:chomp)

class Node
  attr_reader :value
  attr_accessor :successors, :predecessors, :visited
  attr_accessor :onprocess, :processed, :ttl
  def initialize(value)
    @value        = value
    @successors   = []
    @predecessors = []
    @visited      = false
    @onprocess    = false
    @processed    = false
    @ttl = 0
  end

  def ==(other)
    self.value == other.value
  end

  def <=>(other)
    self.value <=> other.value
  end

  def sink?
    successors.empty?
  end

  def source?
    predecessors.empty?
  end
end

nodes = []

inputs.each do |instruction|
  start_node_value, end_node_value = instruction.scan(/\s([A-Z])\s/).flatten
  if (index = nodes.find_index(Node.new(start_node_value)))
    start_node = nodes[index]
  else
    start_node = Node.new(start_node_value)
    nodes << start_node
  end

  if (index = nodes.find_index(Node.new(end_node_value)))
    end_node = nodes[index]
  else
    end_node = Node.new(end_node_value)
    nodes << end_node
  end
  start_node.successors << end_node
  end_node.predecessors << start_node
end

source_nodes = []

nodes.each do |n|
  source_nodes << n if n.source?
end

steps= ""

nodes_to_visit = source_nodes.dup

while !nodes_to_visit.empty?
  current_node = nodes_to_visit.sort!.shift
  current_node.visited = true

  steps << current_node.value

  current_node.successors.each do |successor|
    next if (successor.visited || nodes_to_visit.include?(successor))
    if successor.predecessors.all? {|e| e.visited }
      nodes_to_visit << successor
    end
  end
end

puts "The step to be taken: #{steps}"

time_taken = {}
('A'..'Z').each_with_index do |e, i|
  time_taken[e] = (i + 1) + 60
end

work_pool = source_nodes.dup

free_worker = 5
current_time = -1

done = ""
factory = []

# put first batch of work into factory
work_pool.sort!.each do |work|
  break if free_worker == 0

  work.ttl = time_taken[work.value]
  work.onprocess = true

  if free_worker > 0
    factory << work
    free_worker -= 1
  end
end

work_pool.reject! {|e| e.onprocess}

loop do
  current_time += 1

  factory.each do |work|
    if current_time >= work.ttl
      work.processed = true
      work.successors.each do |successor|
        next if (successor.processed || successor.onprocess || work_pool.include?(successor))
        if successor.predecessors.all? {|e| e.processed }
          work_pool << successor
        end
      end
      free_worker += 1
      done << work.value
    end
  end
  factory.reject! {|e| e.processed}

  # add work to factory if possible
  work_pool.sort!.each do |work|
    break if free_worker == 0

    work.ttl = current_time + time_taken[work.value]
    work.onprocess = true

    factory << work unless factory.include? work
    free_worker -= 1
  end
  work_pool.reject! {|e| e.onprocess}

  break if factory.empty?
end

puts "Parallel: #{done} in time #{current_time}"
