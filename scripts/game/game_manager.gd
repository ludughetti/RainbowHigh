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
	
	# AI Right
	var ai_right = AIPlayerScene.instantiate()
	ai_right.set_up_player("AI Right")
	players.append(ai_right)
	ai_right_area.add_child(ai_right)
	
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

func start_game():
	# Deal initial 5 cards to each player
	for player in players:
		print("Dealing cards for player " + player.player_name)
		for i in range(5):
			var card = deck.draw_card()
			player.add_card_to_hand(card)
			print("Dealt card: " + card.card_name)
			
		# TEMP ------------------
		if player.player_name == "Player":
			var special_card := CardCharacterData.new()
			special_card.setup_card(CardConstants.CardCharacter.PROM_QUEEN)
			player.add_card_to_hand(special_card)
			
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
	
	# Print who's playing
	print("Starting %s turn..." % current_player.player_name)
	
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
		
	# AI logic trigger
	if current_player is AIPlayer:
		current_player.ai_take_turn()

	# selected_card will be null if it's a pass, and CardData if it's discard
	var selected_card = await current_player.action_requested
	if selected_card != null:
		# Discard the card that was played
		current_player.discard_from_hand(selected_card)
		deck.discard_card(selected_card)
		
		# Trigger effect if it's a character card
		if selected_card.card_type == CardConstants.CardType.CHARACTER:
			on_character_card_effect(
				(selected_card as CardCharacterData).character_type,
				current_player
			)
			
	# Update player UI
	current_player.update_ui()
	current_player.toggle_is_player_turn(false)
	await get_tree().process_frame
	
	print("Turn finished for %s" % current_player.player_name)

	# End turn, next player
	await end_turn()

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
	
# Force players to discard if they have more than 7 cards and apply effects if applicable
func enforce_hand_limit(player: BasePlayer) -> void:
	while player.hand.size() > 7:
		print("%s has too many cards. Forcing discard..." % player.player_name)
		player.update_ui()
		
		# If it's an AI, pick and emit immediately
		if player is AIPlayer:
			var ai_card_to_discard = (player as AIPlayer).pick_discard_card()
			player.emit_signal("action_requested", ai_card_to_discard)
		
		var card_to_discard: CardData = await player.action_requested
		if card_to_discard:
			# 🔁 If another character card is discarded, apply its effect
			if card_to_discard.card_type == CardConstants.CardType.CHARACTER:
				on_character_card_effect(
					(card_to_discard as CardCharacterData).character_type,
					player
				)

			player.discard_from_hand(card_to_discard)
			deck.discard_card(card_to_discard)
			player.update_ui()

# Handler for deciding on what to do depending on character type
func on_character_card_effect(character_type: CardConstants.CardCharacter, player: BasePlayer):
	print("GameManager resolving: %s effect", character_type)
	match character_type:
		CardConstants.CardCharacter.MATH_TEACHER:
			await apply_effect_math_teacher(player)
		CardConstants.CardCharacter.SPORTSY:
			await apply_effect_sportsy(player)
		CardConstants.CardCharacter.PROM_QUEEN:
			await apply_effect_prom_queen(player)

func apply_effect_math_teacher(player: BasePlayer):
	print("Math Teacher: Drawing 2 extra cards")
	for i in range(2):
		var extra_card = deck.draw_card()
		player.add_card_to_hand(extra_card)
	player.update_ui()
	
	await enforce_hand_limit(player)

func apply_effect_sportsy(player: BasePlayer):
	var current_index := players.find(player)
	if current_index == -1:
		print("Error: Player not found")
		return

	var target_index := (current_index + 1) % players.size()
	var target_player: BasePlayer = players[target_index]

	if target_player.hand.is_empty():
		print("%s tried to steal from %s, but their hand is empty" % [player.player_name, target_player.player_name])
		return

	# Pick a random card to steal
	var stolen_card: CardData = target_player.hand.pick_random()
	target_player.hand.erase(stolen_card)
	player.hand.append(stolen_card)

	print("%s stole a card from %s!" % [player.player_name, target_player.player_name])

	target_player.update_ui()
	player.update_ui()

	await enforce_hand_limit(player)

func apply_effect_prom_queen(player: BasePlayer):
	# Find the player(s) with the largest hand
	var max_size := -1
	var candidates: Array[BasePlayer] = []

	for p in players:
		# Skip the one who played the Prom Queen
		if p == player:
			continue  
		
		# Else, find player with the most cards
		if p.hand.size() > max_size:
			max_size = p.hand.size()
			candidates = [p]
		elif p.hand.size() == max_size:
			candidates.append(p)

	# Choose first player among those with most cards (for now)
	var target := candidates[0]

	print("Prom Queen: %s has the most cards and must discard one" % target.player_name)

	# Force discard
	target.update_ui()
	if target is AIPlayer:
		var discard := (target as AIPlayer).pick_discard_card()
		target.call_deferred("emit_signal", "action_requested", discard)

	var selected: CardData = await target.action_requested

	if selected:
		# Check for nested character effect
		if selected.card_type == CardConstants.CardType.CHARACTER:
			await on_character_card_effect(
				(selected as CardCharacterData).character_type,
				target
			)

		target.discard_from_hand(selected)
		deck.discard_card(selected)
		target.update_ui()
