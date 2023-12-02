require 'nokogiri'
require 'open-uri'

# input data
input = Nokogiri::HTML5(URI.open("input.html")).text
input = input.split("\n")

# test data
test_input = ["Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green",
"Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue",
"Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red",
"Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red",
"Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green"]

game_conditions = {
  "red" => 12,
  "green" => 13,
  "blue" => 14
}

valid_games = []

def game_string_to_array(string)
  string.split(": ")[1].split(";").map(&:strip)
end

def draw_to_hash(string)
  game = string.split(",").map(&:strip)
  draw_hash = {}
  game.each do | draw |
    number = draw.match (/\d+/)
    colour = draw.match (/red|blue|green/)
    draw_hash[colour[0]] = number[0].to_i
  end
  draw_hash
end

def valid_game?(game, game_conditions)
  game.each do | draw |
    draw.each do | key, value |
      return false if value > game_conditions[key]
    end
  end
  true
end

input.each_with_index do | game, index |
  game_array = game_string_to_array(game)
  game = game_array.map { | game | draw_to_hash(game)}
  # p "Game #{index + 1}"
  valid_games << (index + 1) if valid_game?(game, game_conditions)
end

p valid_games.sum
