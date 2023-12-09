require 'nokogiri'
require 'open-uri'

# input data
input = Nokogiri::HTML5(URI.open("input.html")).text
input = input.split("\n")

# test data
# input = [ ".......467",
#           "...*63.*..",
#           ".67....35.",
#           "......#...",
#           "617*......",
#           ".....+.58.",
#           "..592.....",
#           "......755.",
#           "...$.*....",
#           ".664.598.."]

def y_axis_matches(position, adjacent_string)
  diagonal_grid = [position - 1, position, position + 1]
  adjacent_numbers_index = adjacent_string.enum_for(:scan, /\d+/).map { Regexp.last_match.begin(0) }
  adjacent_numbers = adjacent_string.scan(/\d+/)
  grid_overlap = []
  adjacent_numbers.each_with_index do |number, index|
    number_length = number.length
    start = adjacent_numbers_index[index]
    finish = adjacent_numbers_index[index] + (number_length - 1)
    grid_overlap << ((start..finish).to_a)
  end
  hits = []
  grid_overlap.each_with_index do | number_indexes, index |
    hits << adjacent_numbers[index] if diagonal_grid.intersect?(number_indexes)
  end
  hits
end

def x_axis_matches(string, position)
  array = []
  string = string.split("")
  index_before = string[position - 1]
  index_after = string[position + 1]

  if index_before =~ /\d/
    before = string.dup
    before = before.shift(position).reverse.join.match(/\d+/)
    array << before[0].reverse if before
  end

  if index_after =~ /\d/
    after = string.dup
    after = after.pop(string.length - (position + 1)).join.match(/\d+/)
    array << after[0] if after
  end
  array
end
gear_ratio = []

input.each_with_index do |line, index|
    symbol_positions = line.enum_for(:scan, "*").map { Regexp.last_match.begin(0) }
    line_before = input[index - 1] if index > 0
    line_after = input[index + 1]  unless index == input.count - 1
    if symbol_positions.any?
      symbol_positions.each do |position|
        array = x_axis_matches(line, position)
        hits_above = y_axis_matches(position, line_before) if line_before
        hits_above.each { |hit| array << hit} if hits_above
        hits_below = y_axis_matches(position, line_after) if line_after
        hits_below.each { |hit| array << hit} if hits_below
        "#{array}, #{(array[0].to_i) * (array[1].to_i)}" if array.count
        gear_ratio << (array[0].to_i) * (array[1].to_i) if array.count == 2
        gear_ratio.sum if array.count == 2
      end
  end
end
p gear_ratio.sum
