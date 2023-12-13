require 'nokogiri'
require 'open-uri'

t0 = Time.now

# input data
# input = Nokogiri::HTML5(URI.open("input.html")).text
# input = input.split("\n")

input = <<~INPUT
seeds: 79 14 55 13

seed-to-soil map:
50 98 2
52 50 48

soil-to-fertilizer map:
0 15 37
37 52 2
39 0 15

fertilizer-to-water map:
49 53 8
0 11 42
42 0 7
57 7 4

water-to-light map:
88 18 7
18 25 70

light-to-temperature map:
45 77 23
81 45 19
68 64 13

temperature-to-humidity map:
0 69 1
1 0 69

humidity-to-location map:
60 56 37
56 93 4
INPUT


seeds = input.split("\n\n").map { |string| string.split("\n")}
seeds = seeds[0][0].split(":")
seed_numbers = seeds[1].strip.split(" ").map {|number| number.to_i}

array_of_all_maps = []
maps_string = input.split("map:")
map_numbers = maps_string.map! {|map| map.scan(/\d+/)}
map_numbers.each { |numbers_array| numbers_array.map! {|number| number.to_i}}.shift
map_numbers.each do |number_array|
  map = []
  number_array.each_slice(3) { |numbers| map << numbers}
  array_of_all_maps << map
end

# array_of_all_maps.each { |map| p map.count}

def convert(input, map)
  start_ranges = []
  destination_ranges = []
  difference = []
  map.each do | line |
    start_ranges << Range.new(line[1], (line[1] + line[2]))
    destination_ranges << Range.new(line[0], (line[0] + line[2]))
    difference << line[0] - line[1]
  end
  output = input

  start_ranges.each_with_index do |range, index|
    if range.include?(input)
      output = input + difference[index]
    end
  end
  p output
end

seed_numbers.each do |seed_number|
  # array_of_all_maps.each do |map|
  #   convert(seed_number, map)
  # end
  # convert(seed_number, array_of_all_maps[0])
end



puts "Time elapsed #{Time.now - t0}"
