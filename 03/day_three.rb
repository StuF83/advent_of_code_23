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
# "...*......",
# "..35..633.",
# "......#...",
# "617*......",
# ".....+.58.",
# "..592.....",
# "......755.",
# "...$.*....",
# ".664.598.."]

# horizonaly we can use regxp to find numbers next to a symbol
# vertically we will need to know the index of symbols on the lines above and below
# so we can then compare a number that overlaps the symbol.
# Diagonaly adjacent count, so the overlap needs to extend one index either side.
# We need to make sure we don't duplicate numbers if there are symbols above and below.

machine_parts = []

def find_numbers_in_line(line)
  line.scan(/(?<=[^a-zA-Z.\d])\d+|\d+(?=[^a-zA-Z.\d])/)
end

def remove_number_from_line(line)
  line = line.gsub(/(?<=[^a-zA-Z.\d])\d+|\d+(?=[^a-zA-Z.\d])/) { | match | "."*match.length}
end

def check_previous_line(line, previous_line)
  diagonal_c = []
  previous_line.split("").each_with_index do |ch, index |
    diagonal = index if ch.match(/[^a-zA-Z.\d]/)
    diagonal_c << [(diagonal - 1), (diagonal), (diagonal + 1)] if diagonal
  end
  # p diagonal_c
  hit = []
  line_dup = line.dup
  if  line.scan(/\d+/)[0] && diagonal_c.empty? == false
    # p line.scan(/\d+/)
      line.scan(/\d+/).each do | result |
        # p result
        # number_length = result.length - 1
        # p line.index(/\d+/)
        number_index = Range.new(line.index(/\d+/), (line.index(/\d+/) + (result.length - 1))).to_a if line.scan(/\d+/)[0]
        # p number_index
        diagonal_c.each do | symbol |
          if number_index.intersect?(symbol)
            # p "#{result} = #{number_index}"
            # p symbol
            number_index.each do |i|
              line_dup[i] = "."
            end

            # p line_dup
            hit << result
          end
        end
        # p hit
        line.sub!(result, "."* result.length)
      end
  end
  # p hit
  return line_dup, hit
end

def check_next_line(line, next_line)
  diagonal_c = []
  next_line.split("").each_with_index do |ch, index |
    diagonal = index if ch.match(/[^a-zA-Z.\d]/)
    diagonal_c << [(diagonal - 1), (diagonal), (diagonal + 1)] if diagonal
  end
  # p diagonal_c
  hit = []
  line_dup = line.dup
  if  line.scan(/\d+/)[0] && diagonal_c.empty? == false
    line.scan(/\d+/).each do | result |
      number_length = result.length - 1
      number_index = Range.new(line.index(/\d+/), (line.index(/\d+/) + number_length)).to_a if line.scan(/\d+/)[0]
      diagonal_c.each do | symbol |
        if number_index.intersect?(symbol)
          number_index.each do |i|
            line_dup[i] = "."
          end
          hit << result
        end
      end
      line.sub!(result, "."* result.length)
    end
end
return line_dup, hit
end



input.each_with_index do | line, index |
  # if index ==72

    find_numbers_in_line(line).each {| match | machine_parts << match.to_i }
    line = remove_number_from_line(line)
    previous_line = input[index - 1] if index > 0
    next_line = input[index + 1] if index < (input.length - 1 )
    # p previous_line
    # p line
    # p next_line
    if previous_line
      result = check_previous_line(line, previous_line)
      line = result[0]
      parts = result[1]
      parts.each { | part | machine_parts << part.to_i}
    end
    if next_line
      result = check_next_line(line, next_line)
      line = result[0]
      parts = result[1]
      parts.each { | part | machine_parts << part.to_i}
    end
    # p index + 1
    p line
  # end
end
# p machine_parts
p machine_parts.sum
