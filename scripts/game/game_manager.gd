extends Node

@onready var deck_container = $"/root/Game/DeckContainer"
@onready var player_area = $"/root/Game/PlayerArea"
@onready var ai_opposite_area = $"/root/Game/AIPlayerOpposite"
@onready var ai_left_area = $"/root/Game/AIPlayerLeft"
@onready var ai_right_area = $"/root/Game/AIPlayerRight"

const DeckScene = preload("res://scenes/cards/deck.tscn")
const PlayerScene = preload("res://scenes/game/player.tscn")
const AIPlayerScene = preload("res://scenes/game/ai_player.tscn")
const ResultScene = preload("res://scenes/game/result_screen.tscn")

var deck
var players = []
var current_player_index: int = 0
var is_game_active: bool = true

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
	deck_container.add_child(deck) # make sure this is the correct path

func setup_players():
	var player = PlayerScene.instantiate()
	player.set_up_player("Player")
	players.append(player)
	player_area.add_child(player)
	
	# AI Opposite
	var ai_opposite = AIPlayerScene.instantiate()
	ai_opposite.set_up_player("AI Opposite")
	players.append(ai_opposite)
	ai_opposite_area.add_child(ai_opposite)
	
	# AI Left
	var ai_left = AIPlayerScene.instantiate()
	ai_left.set_up_player("AI Left")
	players.append(ai_left)
	ai_left_area.add_child(ai_left)

	# AI Right
	var ai_right = AIPlayerScene.instantiate()
	ai_right.set_up_player("AI Right")
	players.append(ai_right)
	ai_right_area.add_child(ai_right)

func start_game():
	# Deal initial 5 cards to each player
	for player in players:
		print("Dealing cards for player " + player.player_name)
		for i in range(5):
			var card = deck.draw_card()
			player.add_card_to_hand(card)
			print("Dealt card: " + card.card_name)
		player.update_ui()
			
	call_deferred("run_game_loop")

func run_game_loop():
	var current_player
	
	while is_game_active:
		current_player = players[current_player_index]
		await play_turn(current_player)
	
	# Get the Result scene
	show_victory_screen(current_player)
	
func play_turn(current_player: BasePlayer):
	# Set turn active in player
	current_player.toggle_is_player_turn(true)
	
	# Show UI
	current_player.update_ui()
	await get_tree().create_timer(2).timeout

	# Draw card and update UI
	var drawn_card = deck.draw_card()
	current_player.add_card_to_hand(drawn_card)
	current_player.update_ui()
	await get_tree().process_frame
	
	if current_player.has_full_rainbow():
		# Set this to false and exit the turn loop
		is_game_active = false
		return  

	# selected_card will be null if it's a pass, and CardData if it's discard
	var selected_card = await current_player.action_requested
	if selected_card != null:
		current_player.discard_from_hand(selected_card)
		deck.discard_card(selected_card)

	# Update player UI
	current_player.update_ui()
	current_player.toggle_is_player_turn(false)
	await get_tree().process_frame

	# End turn, next player
	end_turn()

func show_victory_screen(current_player: BasePlayer):
	print("%s wins!" % current_player.player_name)
	await get_tree().create_timer(2).timeout
	
	#Load end result scene
	Global.winner_name = current_player.player_name
	get_tree().change_scene_to_file("res://scenes/game/result_screen.tscn")
	
func wait_for_action(player: BasePlayer) -> CardData:
	return await player.action_requested

func draw_card_for(player_ref):
	var drawn_card = deck.draw_card()
	player_ref.add_card_to_hand(drawn_card)
	
func discard_from_hand(player_ref, card):
	player_ref.discard_from_hand(card)
	deck.discard_card(card)

func end_turn():
	current_player_index = (current_player_index + 1) % players.size()
	print("Turn ended, waiting for next player...")
	await get_tree().create_timer(2).timeout
