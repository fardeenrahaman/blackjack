# Object Oriented Blackjack Game

# 1. Abstraction
# 2. Encapsulation

# require 'rubygems'
# require 'pry'

#------------------------------------------------------------------------------
class Card
	attr_accessor :suit, :face_value

	def initialize(s, fv)
		@suit = s
		@face_value = fv
	end

	def pretty_output
		"The #{face_value} of #{find_suit}"
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

#------------------------------------------------------------------------------
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

#------------------------------------------------------------------------------
module Hand
	
	def show_hand
		puts "---- #{name}'s Hand ----"
		cards.each do |card|
			puts "#{card.to_s}"
		end
		puts "#{name}'s Total: #{total}"
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
			total -= 10 if total > Blackjack::BLACKJACK_AMOUNT
		end

		total
	end

	def add_card(new_card)
		cards << new_card
	end

	def is_busted?
		total > Blackjack::BLACKJACK_AMOUNT
	end

end

#------------------------------------------------------------------------------
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

#------------------------------------------------------------------------------
class Dealer
	include Hand

	attr_accessor :name, :cards

	def initialize
		@name = "Dealer"
		@cards = []
	end

	def show_flop
		puts "---- Dealer's Hand ----"
		puts "First Card is #{cards[0]}"
		puts "Second Card is Hidden.."
	end

end

#------------------------------------------------------------------------------
class Blackjack
	attr_accessor :deck, :player, :dealer, :cards

	BLACKJACK_AMOUNT = 21
	DEALER_HIT_MIN = 17

	def initialize
		@deck = Deck.new 
		@player = Player.new("Player 1")
		@dealer	= Dealer.new
		@cards =  dealer.cards
	end

	def set_player_name
		# puts "What's your name?"
		player.name = "Fardeen"
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
# =======================================
#         | BlackJack-OR-BUST |
# =======================================
	def blackjack_or_bust?(player_or_dealer)
		if player_or_dealer.total == Blackjack::BLACKJACK_AMOUNT
			if player_or_dealer.is_a?(Dealer)
				puts "Sorry! Dealer Hit Blackjack. #{player.name} Loses."
			else
				puts "Congrats! #{player.name} Hits BlackJack & Wins!!"
			end
			play_again?
		elsif player_or_dealer.is_busted?
			if player_or_dealer.is_a?(Dealer)
				puts "Dealer Busted!! #{player.name} Wins!!"
			else
				puts "#{player.name} Busted!! #{player.name} Loses."
			play_again?
			end
		end
	end
# =======================================
#            | Player Turn |
# =======================================
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
		puts "#{player.name} Stays at #{player.total}"
		
	end
# =======================================
#         	 | Dealer Turn |
# =======================================
	def dealer_turn
		puts "Dealer's Turn"
		puts "---- Dealer Shows ----"
		puts "First Card is #{cards[0]}"
		puts "Second Card is #{cards[1]}"
		puts "Dealer's total: #{dealer.total}"
		
		blackjack_or_bust?(dealer)

		while dealer.total < Blackjack::DEALER_HIT_MIN
			new_card = deck.deal_one
			puts "Dealing New Card to Dealer: #{new_card.to_s}"
			dealer.add_card(new_card)
			puts "Dealer's total is now: #{dealer.total}"

			blackjack_or_bust?(dealer)
		end
		puts "Dealer Stays at #{dealer.total}"
	end

	def who_won?
		if (player.total > dealer.total)
			puts "#{player.name} Wins!!"
		elsif (player.total < dealer.total)
			puts "#{player.name} Loses!!"
		else
			puts "It's A Tie!!"
		end
		play_again?
	end

	def play_again?
		puts ""
		puts "Would you like to Play again: 1) Yes 2) No"

		if gets.chomp == '1'
			puts "------------------ Starting New Game ------------------"
			puts ""
			deck = Deck.new
			player.cards = []
			dealer.cards = []
			start
		else gets.chomp == '2'
			puts "Goodbye!!"
			exit
		end
	end

	def start
		set_player_name
		deal_cards
		show_flop
		player_turn
		dealer_turn
		who_won?
	end

end

#------------------------------------------------------------------------------
game = Blackjack.new
game.start




