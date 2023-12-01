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
