extends Control
class_name BasePlayer

const ColorCardScene: PackedScene = preload("res://scenes/cards/card_color.tscn")
const JokerCardScene: PackedScene = preload("res://scenes/cards/card_joker.tscn")
const CardCharacterScene: PackedScene = preload("res://scenes/cards/card_character.tscn")
const CardBackScene: PackedScene = preload("res://scenes/cards/card_back.tscn")

var player_name: String
var hand: Array[CardData] = []
var is_player_turn: bool = false

signal action_requested(card: CardData)

func set_up_player(new_name: String):
	player_name = new_name

func add_card_to_hand(card: CardData):
	hand.append(card)

func discard_from_hand(card: CardData):
	hand.erase(card)

func toggle_is_player_turn(is_turn: bool):
	is_player_turn = is_turn

func has_full_rainbow() -> bool:
	var colors_collected = {}
	var joker_count = 0
	for card_data in hand:
		match card_data.card_type:
			CardConstants.CardType.COLOR:
				colors_collected[card_data.card_color] = true
			CardConstants.CardType.JOKER:
				joker_count += 1
	var missing_colors = 7 - colors_collected.size()
	return joker_count >= missing_colors

func create_new_card_ui(card: CardData, card_type: CardConstants.CardType) -> Card:
	var new_card_ui: Card = null
	match card_type:
		CardConstants.CardType.BACK:
			new_card_ui = CardBackScene.instantiate()
		CardConstants.CardType.COLOR:
			new_card_ui = ColorCardScene.instantiate()
			new_card_ui.set_card_data(card)
		CardConstants.CardType.JOKER:
			new_card_ui = JokerCardScene.instantiate()
			new_card_ui.set_card_data(card)
		CardConstants.CardType.CHARACTER:
			new_card_ui = CardCharacterScene.instantiate()
			new_card_ui.set_card_data(card)
		_:
			push_error("Unknown card type: %s" % card.card_type)
			return null
			
	return new_card_ui

func update_ui():
	# Default: do nothing. Subclasses override.
	pass
