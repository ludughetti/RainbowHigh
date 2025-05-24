extends Control
class_name Player

const ColorCardScene: PackedScene = preload("res://scenes/cards/card_color.tscn")
const JokerCardScene: PackedScene = preload("res://scenes/cards/card_joker.tscn")

var hand: Array[Card] = []
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
		var new_card = create_new_card(card)
		if new_card:
			new_card.connect("card_clicked", Callable(self, "_on_card_clicked"))
			hand_container.add_child(new_card)

func _on_card_clicked(card: Card) -> void:
		emit_signal("discard_requested", card)
		
func create_new_card(card: Card) -> Card:
	var new_card = null
	match card.card_type:
		CardConstants.CardType.COLOR:
			new_card = ColorCardScene.instantiate()			
		CardConstants.CardType.JOKER:
			new_card = JokerCardScene.instantiate()
		_:
			push_error("Unknown card type: %s" % card.card_type)
			return new_card
	
	new_card.set_card_data(card)
	return new_card
