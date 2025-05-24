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
var is_game_active: bool = true
#var ai_player = preload("res://scenes/AIPlayer.tscn")

func _ready():
	# Instance and add deck
	setup_deck()
	# Instance and add player
	setup_players()
	# Start the game
	start_game()
	
func setup_deck():
	deck = DeckScene.instantiate()
	deck.restart_deck()
	deck_container.add_child(deck)
	
func setup_players():
	var player = PlayerScene.instantiate()
	players.append(player)
	player_area.add_child(player)
	
	# Instance and add AI player
	# var ai_instance = ai_player.instantiate()
	# ai_area.add_child(ai_instance)

func start_game():
	# Deal initial 5 cards to each player
	for player in players:
		for i in range(5):
			var card = deck.draw_card()
			player.add_card_to_hand(card)
			
	call_deferred("run_game_loop")

func run_game_loop():
	while is_game_active:
		var current_player = players[current_player_index]
		await play_turn(current_player)
	
func play_turn(current_player: Player):
	# Show UI
	current_player.update_ui()
	await get_tree().process_frame

	# Draw card and update UI
	var drawn_card = deck.draw_card()
	current_player.add_card_to_hand(drawn_card)
	current_player.update_ui()
	await get_tree().process_frame

	# Wait for click and discard the card
	var discarded_card := await wait_for_discard(current_player)
	current_player.discard_from_hand(discarded_card)
	deck.discard_card(discarded_card)

	# Update player UI
	current_player.update_ui()
	await get_tree().process_frame
	await get_tree().create_timer(2).timeout

	# End turn, next player
	end_turn()
	
func wait_for_discard(player: Player) -> CardData:
	return await player.discard_requested

func draw_card_for(player_ref):
	var drawn_card = deck.draw_card()
	player_ref.add_card_to_hand(drawn_card)
	
func discard_from_hand(player_ref, card):
	player_ref.discard_from_hand(card)
	deck.discard_card(card)

func end_turn():
	current_player_index = (current_player_index + 1) % players.size()
