extends Control
class_name Player

const ColorCardScene: PackedScene = preload("res://scenes/cards/card_color.tscn")
const JokerCardScene: PackedScene = preload("res://scenes/cards/card_joker.tscn")

var player_name: String
var hand: Array[CardData] = []
var is_player_turn: bool = false

# UI nodes
@onready var hand_container = $HandContainer  
@onready var pass_button = $PassButton

signal action_requested(card: Card)

func _ready():
	pass_button.connect("pressed", Callable(self, "_on_pass_pressed"))
	
func set_up_player(new_name: String):
	player_name = new_name

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
	
	# Show Pass button only if hand < 7
	pass_button.visible = is_player_turn and hand.size() <= 7  

func _on_card_clicked(card: CardData) -> void:
		emit_signal("action_requested", card)
		
func _on_pass_pressed():
	pass_button.visible = false
	emit_signal("action_requested", null)

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

func toggle_is_player_turn(is_turn: bool):
	is_player_turn = is_turn

func has_full_rainbow() -> bool:
	var colors_collected = {}
	var joker_count = 0
	var total_colors = 7  # Number of colors needed for a full rainbow

	for card_data in hand:
		if card_data.card_type == CardConstants.CardType.COLOR:
			colors_collected[card_data.card_color] = true
		elif card_data.card_type == CardConstants.CardType.JOKER:
			joker_count += 1

	var missing_colors = total_colors - colors_collected.size()
	return joker_count >= missing_colors
