extends Control

const ColorCardScene: PackedScene = preload("res://scenes/cards/card_color.tscn")
const JokerCardScene: PackedScene = preload("res://scenes/cards/card_joker.tscn")

var full_deck: Array[CardData] = []		# Full deck containing all cards
var current_deck: Array[CardData] = []	# Deck to be used in-game
var discard_deck: Array[CardData] = []	# Discard deck temporarily containing all discarded cards

func _ready():
	populate_full_deck()
	restart_deck()
	update_ui()
	
# Create all cards and add them to the full deck
func populate_full_deck():
	full_deck.clear()
	
	# Add all color cards
	for i in 5:
		for color in CardConstants.CardColor.values():
			var card = CardColorData.new()
			card.setup_card(color)
			full_deck.append(card)
	
	# Add jokers
	for j in 2:
		var joker = CardJokerData.new()
		joker.setup_card()
		full_deck.append(joker)
		
	# Add 1 of each character card
	for character in CardConstants.CardCharacter.values():
		if character == CardConstants.CardCharacter.NONE:
			continue  # Skip placeholder
		
		var special = CardCharacterData.new()
		special.setup_card(character)
		full_deck.append(special)

# Reset current deck to full deck
func restart_deck():
	current_deck = full_deck.duplicate()
	shuffle()

# Shuffle current deck
func shuffle():
	current_deck.shuffle();
	
func draw_card() -> CardData:
	if current_deck.is_empty():
		reshuffle_from_discard()
		update_ui()
	elif current_deck.size() - 1 == 0:
		$DiscardContainer/CardImage.visible = false
		
	return current_deck.pop_front()

func discard_card(card: CardData):
	discard_deck.append(card)
	update_ui()

func reshuffle_from_discard():
	# If nothing to reshuffle, early return
	if discard_deck.is_empty():
		return  
	
	current_deck = discard_deck.duplicate()
	discard_deck.clear()
	shuffle()	
	$DiscardContainer/CardImage.visible = true

func get_top_discarded_card() -> CardData:
	if discard_deck.is_empty():
		return null
	return discard_deck[-1]
	
func reset_all():
	discard_deck.clear()
	restart_deck()

func update_ui():
	$DeckContainer/CardCount.text = str(current_deck.size())
	$DiscardContainer/CardCount.text = str(discard_deck.size())
	
	if !current_deck.is_empty():
		$DeckContainer/CardImage.visible = true
	else:
		$DeckContainer/CardImage.visible = false
	
	var top_card = get_top_discarded_card()
	if !discard_deck.is_empty() and top_card:
		$DiscardContainer/CardImage.texture = top_card.card_texture_idle
	else:
		$DiscardContainer/CardImage.texture = null
		
	await get_tree().process_frame
