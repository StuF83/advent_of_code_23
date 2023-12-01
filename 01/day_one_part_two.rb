require 'nokogiri'
require 'open-uri'
require_relative 'day_one_part_one'

# input data: calibration document
input = Nokogiri::HTML5(URI.open("input.html")).text
input = input.split("\n")

# test data
test_input = ["two1nine",
"eightwothree",
"abcone2threexyz",
"xtwone3four",
"4nineeightseven2",
"zoneight234",
"7pqrstsixteen"]

# we could have a hash of mumbers and their strings

numbers = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]

# we can itterate over each element in the string.
# if it is an integer, return it
# if we use an each with index, can we use a case to check the next number of
# elements to see if they spell the number


# if we take the array of strings and say
# take the array and itterate over it

def find_text_number(array_of_coordinates, array_of_numbers)
  array_of_coordinates_dup = array_of_coordinates.dup
  array_of_coordinates.each do | coordinate |
    return coordinate if (1..9).include?coordinate.to_i
    array_of_numbers.each do | number |
      slice = array_of_coordinates_dup.slice(0, number.length)
      return number if slice == number.split("")
    end
    array_of_coordinates_dup.shift
  end
end

test_input.each do | coordinate_string, index |
  coordinate_array = coordinate_string_to_array(coordinate_string)
  number = find_text_number(coordinate_array, numbers)
  p number
end
