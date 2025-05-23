extends Node

@onready var deck_container = $"/root/Game/DeckContainer"
@onready var player_area = $"/root/Game/PlayerArea"
#@onready var ai_area = $"/root/Game/AIPlayerArea"

const DeckScene = preload("res://scenes/cards/deck.tscn")
const PlayerScene = preload("res://scenes/game/player.tscn")
#const AIPlayerScene = preload("res://scenes/AIPlayer.tscn")

var deck
var players = []
var current_player_index: int = 0
var current_turn = 0
#var ai_player = preload("res://scenes/AIPlayer.tscn")

func _ready():
	# Instance and add deck
	setup_deck()
	# Instance and add player
	setup_players()
	# Start the game
	start_game();
	
func setup_deck():
	deck = DeckScene.instantiate()
	deck.reset_deck()
	deck_container.add_child(deck)
	
func setup_players():
	var player = PlayerScene.instantiate()
	players.add(player)
	player_area.add_child(player)
	
	# Instance and add AI player
	# var ai_instance = ai_player.instantiate()
	# ai_area.add_child(ai_instance)

func start_game():
	# Deal initial 5 cards to each player
	for i in range(5):
		for player in players:
			var card = deck.draw_card()
			player.add_card(card)
			
	start_turn()

func start_turn():
	#var current_player = players[current_player_index]
	#current_player.start_turn()
	pass

func draw_card_for(player_ref):
	var drawn_card = deck.draw_card()
	player_ref.add_card_to_hand(drawn_card)
	
func discard_from_hand(player_ref, card):
	player_ref.discard_from_hand(card)
	deck.discard_card(card)

func end_turn():
	current_player_index = (current_player_index + 1) % players.size()
	start_turn()
