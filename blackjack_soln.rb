# Object Oriented Blackjack Game

# 1. Abstraction
# 2. Encapsulation

# require 'rubygems'
# require 'pry'

class Card
	attr_accessor :suit, :face_value

	def initialize(s, fv)
		@suit = s
		@face_value = fv
	end

	def pretty_output
		puts "The #{face_value} of #{find_suit}"
	end

	def to_s
		pretty_output
	end

	def find_suit
		ret_val = case suit
								when 'H' then 'Hearts'
								when 'D' then 'Diamonds'
								when 'C' then 'Clubs'
								when 'S' then 'Spades'
							end
		ret_val
	end
end

class Deck
	attr_accessor :cards

	def initialize
		@cards = []
		['H', 'D', 'S', 'C'].each do |suit|
			['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A'].each do |face_value|
				@cards << Card.new(suit, face_value)
			end
		end
		scramble!
	end

	def scramble!
		cards.shuffle!
	end

	def deal_one
		cards.pop
	end

	def size
		cards.size
	end
end

module Hand
	
	def show_hand
		puts "---- #{name}'s Hand ----"
		cards.each do |card|
			puts "#{card.to_s}"
		end
		puts "#{name} Total: #{total}"
	end

	def total
		face_values = cards.map{ |card| card.face_value }

		total = 0
		face_values.each do |val|
			if val == 'A'
				total += 11
			else
				total += (val.to_i == 0 ? 10 : val.to_i)
			end
		end

		# Correct Value for Aces
		face_values = cards.select{ |val| val == 'A'}.count.times do
			break if total <= 21
			total -= 10
		end

		total
	end

	def add_card(new_card)
		cards << new_card
	end

	def is_busted?
		total > 21
	end

end

class Player
	include Hand

	attr_accessor :name, :cards

	def initialize(n)
		@name = n
		@cards = []
	end

	def show_flop
		show_hand
	end
end

class Dealer
	include Hand

	attr_accessor :name, :cards

	def initialize
		@name = "Dealer"
		@cards = []
	end

	def show_flop
		puts "---- Dealer's Hand ----"
		puts "First Card is Hidden.."
		puts "Second Card is #{cards[1]}"
	end

end

class Blackjack
	attr_accessor :deck, :player, :dealer

	def initialize
		@deck = Deck.new 
		@player = Player.new("Player 1")
		@dealer	= Dealer.new
	end

	def set_player_name
		puts "What's your name?"
		player.name = gets.chomp
	end

	def deal_cards
		player.add_card(deck.deal_one)
		dealer.add_card(deck.deal_one)
		player.add_card(deck.deal_one)
		dealer.add_card(deck.deal_one)
	end

	def show_flop
		player.show_flop
		dealer.show_flop
	end

	def blackjack_or_bust?(player_or_dealer)
		if player_or_dealer.total == 21
			if player_or_dealer.is_a?(Dealer)
				puts "Sorry! Dealer Hit Blackjack. #{player.name} Loses."
			else
				puts "Congrats! #{player.name} Hits BlackJack & Wins!!"
			end
			exit
		elsif player_or_dealer.is_busted?
			if player_or_dealer.is_a?(Dealer)
				puts "Dealer Busted!! #{player.name} Wins!!"
			else
				puts "#{player.name} Busted!! #{player.name} Loses."
			exit
			end
		end
	end

	def player_turn
		puts "#{player.name}'s Turn"

		blackjack_or_bust?(player)

		while !player.is_busted?
			puts "Would you like to 1) HIT 2) STAY"
			response = gets.chomp

			if !['1', '2'].include?(response)
				puts "ERROR: Please Choose 1) or 2)"
				next
			end

			if response == "2"
				puts "#{player.name} Choose To STAY"
				puts ""
				break
			end

			# Player Hit
			new_card = deck.deal_one
			puts "Dealing New Card to Player: #{player.name}: #{new_card.to_s}"
			player.add_card(new_card)
			puts "#{player.name}'s total is now: #{player.total}"

			blackjack_or_bust?(player)
		end
		puts "#{player.name} Stays"
		
	end

	def start
		set_player_name
		deal_cards
		show_flop
		player_turn
		# dealer_turn
		# who_won?(player, dealer)
	end

end

game = Blackjack.new
game.start

# c1 = Card.new('H', 3)
# c2 = Card.new('C', 6)

# c1.pretty_output
# c2.pretty_output

# deck = Deck.new

# player = Player.new("Bob")
# player.add_card(deck.deal_one)
# player.add_card(deck.deal_one)
# player.show_hand


# dealer = Dealer.new
# dealer.add_card(deck.deal_one)
# dealer.add_card(deck.deal_one)
# dealer.show_hand


