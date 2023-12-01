require 'nokogiri'
require 'open-uri'

# input data: calibration document
input = Nokogiri::HTML5(URI.open("input.html")).text
input = input.split("\n")

# test data
test_input = ["1abc2",
"pqr3stu8vwx",
"a1b2c3d4e5f",
"treb7uchet"]

coordinate_numbers = []

def coordinate_string_to_array(string)
  string.split("")
end

def find_first_number(array)
  array.each { | element| return element if (1..9).include?element.to_i }
end

def find_last_number(array)
  find_first_number(array.reverse!)
end

input.each do | coordinate_string |
  coordinate_array = coordinate_string_to_array(coordinate_string)
  first_number = find_first_number(coordinate_array)
  last_number = find_last_number(coordinate_array)
  coordinate_numbers << first_number.concat(last_number).to_i
end

# puts "The sum for the calibration document is #{coordinate_numbers.sum}"
