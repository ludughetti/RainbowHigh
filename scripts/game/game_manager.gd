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

const CharacterEffectHandler = preload("res://scripts/cards/character_effect_handler.gd")

var deck: DeckManager = null
var players = []
var current_player_index: int = 0
var is_game_active: bool = true
var effect_handler: CharacterEffectHandler

func _ready():
	setup_deck()
	setup_players()
	effect_handler = CharacterEffectHandler.new()
	add_child(effect_handler)
	effect_handler.setup(deck, players)
	
	start_game()

func setup_deck():
	deck = DeckScene.instantiate()
	deck.restart_deck()
	deck_container.add_child(deck)

func setup_players():
	_add_player(PlayerScene, player_area, "Player")
	_add_player(AIPlayerScene, ai_right_area, "AI Right")
	_add_player(AIPlayerScene, ai_opposite_area, "AI Opposite")
	_add_player(AIPlayerScene, ai_left_area, "AI Left")

func _add_player(scene, area, player_name):
	var player = scene.instantiate()
	player.set_up_player(player_name)
	players.append(player)
	area.add_child(player)

func start_game():
	for player in players:
		print("Dealing cards for player " + player.player_name)
		for i in range(5):
			var card = deck.draw_card()
			print("Dealt card: " + card.card_name)
			
			player.add_card_to_hand(card)
			player.update_ui()
			await get_tree().create_timer(1).timeout
			
	call_deferred("run_game_loop")

func run_game_loop():
	var current_player
	while is_game_active:
		current_player = players[current_player_index]
		await play_turn(current_player)
	show_victory_screen(current_player)

func play_turn(current_player: BasePlayer):
	current_player.toggle_is_player_turn(true)
	print("Starting %s turn..." % current_player.player_name)
	current_player.update_ui()
	await get_tree().create_timer(2).timeout

	var drawn_card = deck.draw_card()
	current_player.add_card_to_hand(drawn_card)
	current_player.update_ui()
	await get_tree().create_timer(1).timeout

	if current_player.has_full_rainbow():
		is_game_active = false
		return

	if current_player is AIPlayer:
		current_player.ai_take_turn()

	var selected_card = await current_player.action_requested
	if selected_card != null:
		current_player.discard_from_hand(selected_card)
		current_player.update_ui()
		await get_tree().create_timer(1).timeout
		deck.discard_card(selected_card)
		await get_tree().create_timer(1).timeout
		
		if selected_card.card_type == CardConstants.CardType.CHARACTER:
			await effect_handler.apply((selected_card as CardCharacterData).character_type, current_player)

	current_player.update_ui()
	current_player.toggle_is_player_turn(false)
	await get_tree().process_frame
	print("Turn finished for %s" % current_player.player_name)
	await end_turn()

func show_victory_screen(current_player: BasePlayer):
	print("%s wins!" % current_player.player_name)
	await get_tree().create_timer(2).timeout
	Global.winner_name = current_player.player_name
	get_tree().change_scene_to_file("res://scenes/game/result_screen.tscn")

func end_turn():
	current_player_index = (current_player_index + 1) % players.size()
	print("Turn ended, waiting for next player...")
	await get_tree().create_timer(2).timeout
