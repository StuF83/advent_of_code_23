require 'nokogiri'
require 'open-uri'

# input data
input = Nokogiri::HTML5(URI.open("input.html")).text
input = input.split("\n")

# test data
test_input = ["....411...............838......721.....44..............................................607..................................................",
"...&......519..................*..........#.97.........994..............404..............*...&43........440...882.......673.505.............",
".....*......*...892.........971...%....131....*..........*.......515...$.......157.....412.............-.....*.............*............594.",
"..856.495....13...-...............602..........36...$.985....341*.........88.....*.921....................122..................806..508....."]

# test_input = ["467..114..",
# "123*22....",
# "..35..633.",
# "......#...",
# "617*......",
# ".....+.58.",
# "..592.....",
# "......755.",
# "...$.*....",
# ".664.598.."]

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


def horizontal_matches(string, array)
  positions = string.enum_for(:scan, /([^a-zA-Z\d\n.])/).map { Regexp.last_match.begin(0) }
  if positions.any?
    string = string.split("")
    before = string.shift(positions[0]).reverse.join.match(/\d+/)
    after = string.join.match(/(?<=[^a-zA-Z.\d])\d+/)
    array << before[0].reverse if before
    array << after[0].reverse if after
  end
  array
end

test_input.each do |line|
  adjacent_numbers = []
  adjacent_numbers = horizontal_matches(line, adjacent_numbers)
  p adjacent_numbers
end
