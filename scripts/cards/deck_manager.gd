extends Node2D

const ColorCard: PackedScene = preload("res://scenes/cards/card_color.tscn")
const JokerCard: PackedScene = preload("res://scenes/cards/card_joker.tscn")

@onready var deck_control = $DeckContainer
@onready var discard_control = $DiscardContainer

var full_deck: Array[Card] = []		# Full deck containing all cards
var current_deck: Array[Card] = []	# Deck to be used in-game
var discard_deck: Array[Card] = []	# Discard deck temporarily containing all discarded cards

func _ready():
	populate_full_deck()
	restart_deck()
	update_id()
	
# Create all cards and add them to the full deck
func populate_full_deck():
	full_deck.clear()
	
	# Add all color cards
	for i in 5:
		for color in CardConstants.CardColor.values():
			var card = ColorCard.instantiate()
			card.setup_card(color)
			full_deck.append(card)
	
	# Add jokers
	for j in 2:
		var joker = JokerCard.instantiate()
		joker.setup_card()
		full_deck.append(joker)
		
# Reset current deck to full deck
func restart_deck():
	current_deck = full_deck.duplicate()
	shuffle()

# Shuffle current deck
func shuffle():
	current_deck.shuffle();
	
func draw_card() -> Card:
	if current_deck.is_empty():
		reshuffle_from_discard()
	if current_deck.is_empty():
		return null  # Nothing to draw
		
	return current_deck.pop_front()

func discard_card(card: Card):
	discard_deck.append(card)

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
	
func reset_all():
	discard_deck.clear()
	restart_deck()
	
func update_id():
	deck_control.get_node("CardCount").text = str(current_deck.size())
	discard_control.get_node("CardCount").text = str(discard_deck.size())
	
	var top_card = get_top_discarded_card()
	if top_card:
		discard_control.get_node("CardImage").texture = top_card.get_card_texture()
	else:
		discard_control.get_node("CardImage").texture = null
