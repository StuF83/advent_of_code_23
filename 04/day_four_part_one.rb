require 'nokogiri'
require 'open-uri'

# input data
# input = Nokogiri::HTML5(URI.open("input.html")).text
# input = input.split("\n")

input = <<~INPUT
Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
INPUT

# p input

total = []

class Card
  attr_reader :id, :guesses, :numbers

  def self.parse(line)
    first, *last = line.chomp.split(":")
    id = first.match(/\d+/)[0]
    numbers, guesses = last[0].split("|")
    guesses = guesses.strip
    numbers = numbers.strip
    new(id, guesses, numbers)
  end

  def initialize(id, guesses, numbers)
    @id = id.to_i
    @guesses = guesses
    @numbers = numbers
  end

  def winning_numbers_count?
    guesses = @guesses.split(" ")
    numbers = @numbers.split(" ")
    guesses.intersection(numbers).count
  end

  def score
    wins = self.winning_numbers_count?
    if wins < 1
      0
    else
      (1*2)**(wins - 1)
    end
  end

  def bonus_cards
    self.score
    cards = self.winning_numbers_count? >= 1 ? Range.new(@id + 1, (@id + self.winning_numbers_count?)).to_a : []
    p cards
  end
end

card_pile = Hash.new
card_pile.default = 0

input.each_line do | line |
  card = Card.parse(line)
  card_pile[card.id] += 1
  card_pile[card.id].times do
    card.bonus_cards.each { | id | card_pile[id] += 1 }
  end
end

p card_pile
total_cards = 0
card_pile.each_value { | value | total_cards += value}
p total_cards

# p total.sum
