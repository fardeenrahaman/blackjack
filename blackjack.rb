def blank
	puts ""
end


def calc_total(cards)
	# [['H', '3'], ['S', 'Q'], ... ]
	arr = cards.map{ |e| e[1] }

	total = 0
	arr.each do |value|
		if value == 'A'
			total += 11
		elsif value.to_i == 0 # For J, Q, K
			total +=10
		else
			total += value.to_i
		end
	end

	# Correction for Aces
	arr.select{ |e| e == "A" }.count.times do
		total -= 10 if total > 21
	end

	# if arr.include?('A') && total > 21
	# 	total -= 10
	# end

	total
end

# Start Game
puts "Welcome To BlackJack"

suits = ['H', 'D', 'S', 'C']
cards = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']

deck = suits.product(cards)
deck.shuffle!

# Deal Cards
mycards = []
dealercards = []

mycards << deck.pop
dealercards << deck.pop
mycards << deck.pop
dealercards << deck.pop

dealertotal = calc_total(dealercards)
mytotal = calc_total(mycards)

# Show Cards
puts "Dealer has #{dealercards[0]} & #{dealercards[1]} -> #{dealertotal}"
puts "You have #{mycards[0]} & #{mycards[1]} -> #{mytotal}"
blank

# Player Turn
if mytotal == 21
	puts "Congrats! You Hit BlackJack & Win!"
	exit
end

while mytotal < 21
	puts "Would you like to 1) HIT 2) STAY"
	hit_or_stay = gets.chomp

	if !['1', '2'].include?(hit_or_stay)
		puts "ERROR: Please Choose 1) or 2)"
		next
	end

	if hit_or_stay == "2"
		puts "You Choose To STAY"
		puts ""
		break
	end

	# Player HIT
	new_card = deck.pop
	puts "Dealing New Card to Player: #{new_card}"
	mycards << new_card
	mytotal = calc_total(mycards)
	puts "You now have -> #{mytotal}"
	blank

	if mytotal == 21
		puts "Congrats! You Hit BlackJack & Win!"
		exit
	elsif mytotal > 21
		puts "Sorry! You Are Busted"
		exit
	end
end

# Dealer Turn
if dealertotal == 21
	puts "Sorry! Dealer Hit Blackjack. You Lose."
	exit
end

while dealertotal < 17

	# Dealer HIT
	new_card = deck.pop
	puts "Card Dealt To Dealer -> #{new_card}"
	dealercards << new_card
	dealertotal = calc_total(dealercards)
	puts "Dealer now has -> #{dealertotal}"
	blank

	if dealertotal == 21
		puts "Sorry! Dealer Hit Blackjack. You Lose."
		exit
	elsif dealertotal > 21
		puts "Congrats! Dealer Busted. You Win!"
		exit
	end

end

# Compare Hands
puts "Dealer's Cards "
dealercards.each do |card|
	puts "-> #{card}"
	blank
end
puts "Dealer Total -> #{dealertotal}"
puts ""

puts "Player's Cards "
mycards.each do |card|
	puts "-> #{card}"
	blank
end
puts "Player Total -> #{mytotal}"
blank

if dealertotal > mytotal
	puts "You Lose..."
elsif dealertotal < mytotal
	puts "You Win!"
else
	puts "It's a Tie!!"
end



