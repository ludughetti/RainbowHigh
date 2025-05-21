extends Node

@onready var deck = $DeckContainer/Deck
@onready var discard_display = $DiscardContainer/LastDiscardedCard

var players = []
var current_turn = 0

func _ready():
	deck.reset_deck();
	start_game();

#func start_game():
#	for i in range(players.size()):
#		var card = deck.draw_card()
#		players[i].add_card_to_hand(card)	

func start_game():
	var card = deck.draw_card()
	$Player.add_card_to_hand(card)

	# Optional: simulate discard after 2 seconds
	await get_tree().create_timer(2.0).timeout
	$Player.discard_card(card)
	add_to_discard_pile(card)

func add_to_discard_pile(card):
	discard_pile.append(card)
