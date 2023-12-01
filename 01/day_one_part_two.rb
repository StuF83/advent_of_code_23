require 'nokogiri'
require 'open-uri'

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

coordinate_numbers = []
numbers = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]
numbers_reverse = numbers.map { | string | string.reverse}

numbers_hash = {"one" => 1, "two" => 2, "three" => 3, "four" => 4, "five" => 5, "six" => 6, "seven" => 7, "eight" => 8, "nine" => 9}

def coordinate_string_to_array(string)
  string.split("")
end

def find_first_text_number(array_of_coordinates, array_of_numbers)
  array_of_coordinates_dup = array_of_coordinates.dup
  array_of_coordinates.each do | coordinate |
    return coordinate.to_i if (1..9).include?coordinate.to_i
    array_of_numbers.each do | number |
      slice = array_of_coordinates_dup.slice(0, number.length)
      return number if slice == number.split("")
    end
    array_of_coordinates_dup.shift
  end
end

def find_last_text_number(array_of_coordinates, array_of_numbers_reverse)
  array_of_coordinates_dup = array_of_coordinates.dup
  array_of_coordinates.each do | coordinate |
    return coordinate.to_i if (1..9).include?coordinate.to_i
    array_of_numbers_reverse.each do | number |
      slice = array_of_coordinates_dup.slice(0, number.length)
      return number if slice == number.split("")
    end
    array_of_coordinates_dup.shift
  end
end

def conver_number_string_to_int(string, numbers_hash)
  numbers_hash[string]
end

input.each do | coordinate_string, index |
  coordinate_array = coordinate_string_to_array(coordinate_string)
  first_number = find_first_text_number(coordinate_array, numbers)
  first_number = conver_number_string_to_int(first_number, numbers_hash) if first_number.is_a? String
  coordinate_numbers << first_number
  coordinate_array = coordinate_array.reverse
  last_number = find_last_text_number(coordinate_array, numbers_reverse)
  last_number = last_number.reverse if last_number.is_a? String
  last_number = conver_number_string_to_int(last_number, numbers_hash) if last_number.is_a? String
  coordinate_numbers << last_number
end

coordinate_numbers = coordinate_numbers.each_slice(2).to_a
coordinate_numbers = coordinate_numbers.map { | pair | pair.join.to_i}
p coordinate_numbers.sum
