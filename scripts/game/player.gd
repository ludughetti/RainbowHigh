extends Control
class_name Player

var hand: Array[Card] = []
var game_manager = null

# UI node where the cards are shown
@onready var hand_container = $HandContainer  

func add_card_to_hand(card):
	hand.append(card)
	update_ui()
	
func discard_from_hand(card):
	hand.erase(card)
	update_ui()

func update_ui():
	hand_container.clear()
	for card in hand:
		var card_node = card.duplicate()
		card_node.connect("card_clicked", Callable(self, "_on_card_clicked").bind(card_node))
		hand_container.add_child(card_node)

func _on_card_clicked(card: Card) -> void:
	if game_manager:
		game_manager.discard_from_hand(self, card)
