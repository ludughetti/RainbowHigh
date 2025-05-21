extends Control
class_name Player

var hand: Array = []

@onready var hand_container = $HandContainer

func add_card_to_hand(card_scene: Node):
	hand.erase(card_scene)
	card_scene.queue_free()
	
func get_hand_size() -> int:
	return hand.size()

func get_hand() -> Array:
	return hand.duplicate()
