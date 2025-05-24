extends Control
class_name Player

const ColorCardScene: PackedScene = preload("res://scenes/cards/card_color.tscn")
const JokerCardScene: PackedScene = preload("res://scenes/cards/card_joker.tscn")

var hand: Array[CardData] = []
var game_manager = null

# UI node where the cards are shown
@onready var hand_container = $HandContainer  

signal discard_requested(card: Card)

func add_card_to_hand(card):
	hand.append(card)
	
func discard_from_hand(card):
	hand.erase(card)

func update_ui():
	# Clear HBoxContainer
	for hand_card in hand_container.get_children():
		hand_card.queue_free()
	
	# Add the updated cards again
	for card in hand:
		var new_card_ui = create_new_card_ui(card)
		new_card_ui.connect("card_clicked", Callable(self, "_on_card_clicked"))
		hand_container.add_child(new_card_ui)

func _on_card_clicked(card: CardData) -> void:
		emit_signal("discard_requested", card)

func create_new_card_ui(card: CardData) -> Card:
	var new_card_ui = null
	match card.card_type:
		CardConstants.CardType.COLOR:
			new_card_ui = ColorCardScene.instantiate()
		CardConstants.CardType.JOKER:
			new_card_ui = JokerCardScene.instantiate()
		_:
			push_error("Unknown card type: %s" % card.card_type)
			return new_card_ui
	
	new_card_ui.set_card_data(card)
	return new_card_ui
