extends BasePlayer
class_name AIPlayer

@export var action_delay := 1.0
@onready var hand_container = $HandContainer

func update_ui():
	for c in hand_container.get_children():
		c.queue_free()

	for _card in hand:
		# Passes actual card_data but creates a UI Back Card
		var card_back = create_new_card_ui(_card, CardConstants.CardType.BACK)
		hand_container.add_child(card_back)

func ai_take_turn():
	print("%s is taking their turn..." % player_name)

	if hand.size() > 7:
		print("%s discards card" % player_name)
		var to_discard = pick_discard_card()
		emit_signal("action_requested", to_discard)
		return

	print("%s passes" % player_name)
	emit_signal("action_requested", null)

func pick_discard_card() -> CardData:
	# Return the first card in hand
	return hand[0]
