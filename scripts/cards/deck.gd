extends Node2D

var full_deck: Array[Card] = []		# Full deck containing all cards
var current_deck: Array[Card] = []			# Deck to be used in-game
var discard_deck: Array[Card] = []	# Discard deck temporarily containing all discarded cards

signal card_discarded(card: Card)

func _ready():
	populate_full_deck()
	reset_deck()
	
# Create all cards and add them to the full deck
func populate_full_deck():
	full_deck.clear()
	
	# Add all color cards
	for i in 5:
		for color in CardConstants.CardColor.values():
			var card = ColorCard.new()
			card.card_color = color
			full_deck.append(card)
	
	# Add jokers
	for j in 2:
		var joker = JokerCard.new()
		full_deck.append(joker)
		
# Reset current deck to full deck
func reset_deck():
	current_deck = full_deck.duplicate()
	shuffle()

# Shuffle current deck
func shuffle():
	current_deck.shuffle();
	
func draw_card() -> Card:
	if current_deck.is_empty():
		reshuffle_from_discard()
	return current_deck.pop_front()

func discard_card(card: Card):
	discard_deck.append(card)
	emit_signal("card_discarded", card)

func reshuffle_from_discard():
	# If nothing to reshuffle, early return
	if discard_deck.is_empty():
		return  
		
	current_deck = discard_deck.duplicate()
	discard_deck.clear()
	shuffle()	

func get_top_discarded_card() -> Card:
	if discard_deck.is_empty():
		return null
	return discard_deck[-1]
