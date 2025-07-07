extends BasePlayer
class_name Player

@onready var hand_container = $HandContainer
@onready var pass_button = $PassButton

func _ready():
	pass_button.pressed.connect(_on_pass_pressed)

func update_ui():
	for c in hand_container.get_children():
		c.queue_free()

	for card in hand:
		var card_ui = create_new_card_ui(card, card.card_type)
		card_ui.connect("card_clicked", Callable(self, "_on_card_clicked"))
		hand_container.add_child(card_ui)

	pass_button.visible = is_player_turn

func _on_card_clicked(card: CardData):
	emit_signal("action_requested", card)

func _on_pass_pressed():
	pass_button.visible = false
	emit_signal("action_requested", null)
