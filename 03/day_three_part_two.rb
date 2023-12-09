require 'nokogiri'
require 'open-uri'

# input data
input = Nokogiri::HTML5(URI.open("input.html")).text
input = input.split("\n")

# test data
# input = [
#   "....411...............838......721.....44..............................................607..................................................",
#   "...&......519..................*..........#.97.........994..............404..............*...&43........440...882.......673.505.............",
#   ".....*......*...892.........971...%....131....*..........*.......515...$.......157.....412.............-.....*.............*............594.",
#   "..856.495....13...-...............602..........36...$.985....341*.........88.....*.921....................122..................806..508.....",
#   "......................667.325*734.................718...............284..*....288..*....620.......854.............643....817....*...........",
#   "....*480..825..........*....................784.......&.............*...859........856.*..........*...........................137...........",
#   "............*..903*986.681....403.....451...*.....424..24.855....844....................826.......202....-.........542%..564......@.212*....",
#   "......735...70.............=.....*895.......575.....*......*.............490.........+.......114.......890....519...........*857.88.....761."
# ]
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

# we want to find the index of a symbol and the line it is in.
# we can then check if a digit exists in a space in the grid adjacent to it.
# The best approach would possibly be to find all the numbers that surround the symbo, and if there are only two, go from there

# [d d d]
# [d s d]
# [d d d]

# grid system would be x, y such that x is the index of the string, y is the index of the line within the list.
# first check we could make would be left and right of the symbol.
# We need to check the lines above and below:
# Below the grid such that x is [x-1, x, x+1] and y is y-1. If there is no digit, we can move onto the line below. If there is a

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
  # p grid_overlap
  # p adjacent_numbers
  hits = []
  grid_overlap.each_with_index do | number_indexes, index |
    hits << adjacent_numbers[index] if diagonal_grid.intersect?(number_indexes)
  end
  hits
end

def x_axis_matches(string, position)
  array = []
  string = string.split("")
  # p string
  index_before = string[position - 1]
  index_after = string[position + 1]

  if index_before =~ /\d/
    before = string.dup
    before = before.shift(position).reverse.join.match(/\d+/)
    array << before[0].reverse if before
  end
  # p string

  if index_after =~ /\d/
    # p string.slice(0, position)
    after = string.dup
    after = after.pop(string.length - (position + 1)).join.match(/\d+/)
    array << after[0] if after
  end

  p array
end
gear_ratio = []

input.each_with_index do |line, index|
  # if (index + 1) == 21
    p index + 1
    symbol_positions = line.enum_for(:scan, "*").map { Regexp.last_match.begin(0) }
    # p symbol_positions
    # p symblos = symbol_positions.map { |i| line[i]}
    line_before = input[index - 1] if index > 0
    line_after = input[index + 1]  unless index == input.count - 1
    if symbol_positions.any?
      symbol_positions.each do |position|
        array = x_axis_matches(line, position)
        hits_above = y_axis_matches(position, line_before) if line_before
        hits_above.each { |hit| array << hit} if hits_above
        hits_below = y_axis_matches(position, line_after) if line_after
        hits_below.each { |hit| array << hit} if hits_below
        p "#{array}, #{(array[0].to_i) * (array[1].to_i)}" if array.count
        gear_ratio << (array[0].to_i) * (array[1].to_i) if array.count == 2
        gear_ratio.sum if array.count == 2
      end
    # end
    # p gear_ratio.sum
  end
end
p gear_ratio.sum

# answer = 73137087 is too low
