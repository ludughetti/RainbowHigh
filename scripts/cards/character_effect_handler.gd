extends Node
class_name CharacterEffectHandler

var deck: DeckManager = null
var players: Array = []

func setup(deck_ref: DeckManager, players_ref: Array) -> void:
	deck = deck_ref
	players = players_ref

func apply(character_type: CardConstants.CardCharacter, player: BasePlayer) -> void:
	print("CharacterEffectHandler resolving: %s effect", character_type)
	match character_type:
		CardConstants.CardCharacter.MATH_TEACHER:
			await _math_teacher(player)
		CardConstants.CardCharacter.SPORTSY:
			await _sportsy(player)
		CardConstants.CardCharacter.PROM_QUEEN:
			await _prom_queen(player)
		CardConstants.CardCharacter.NOSEY:
			await _nosey(player)
		CardConstants.CardCharacter.THEATER_KID:
			await _theater_kid(player)
		CardConstants.CardCharacter.CLASS_PRESIDENT:
			await _class_president()
		CardConstants.CardCharacter.ART_TEACHER:
			await _art_teacher()
		CardConstants.CardCharacter.BAD_BOY:
			await _bad_boy()
		CardConstants.CardCharacter.HISTORY_TEACHER:
			await _history_teacher()

# === INDIVIDUAL EFFECTS ===

func _math_teacher(player):
	print("Math Teacher: Drawing 2 extra cards")
	for i in 2:
		player.add_card_to_hand(deck.draw_card())
	player.update_ui()
	await _enforce_hand_limit(player)

func _sportsy(player):
	print("Sportsy: Steal a card from the player on the right")
	var i = players.find(player)
	var target = players[(i + 1) % players.size()]
	if target.hand.is_empty(): 
		print("%s tried to steal from %s, but their hand is empty" % [player.player_name, target.player_name])
		return
		
	var stolen = target.hand.pick_random()
	target.hand.erase(stolen)
	player.hand.append(stolen)
	print("%s stole a card from %s!" % [player.player_name, target.player_name])
	
	target.update_ui()
	player.update_ui()
	await _enforce_hand_limit(player)

func _prom_queen(player):
	print("Prom Queen: force the player with the most cards to discard one")
	var max_size = -1
	var candidates = []
	for p in players:
		if p == player:
			continue
		if p.hand.size() > max_size:
			max_size = p.hand.size()
			candidates = [p]
		elif p.hand.size() == max_size:
			candidates.append(p)
			
	var target = candidates[0]
	print("%s has the most cards and must discard one" % target.player_name)
	
	target.update_ui()
	if target is AIPlayer:
		var discard = target.pick_discard_card()
		target.call_deferred("emit_signal", "action_requested", discard)
	var selected: CardData = await target.action_requested
	if selected:
		if selected.card_type == CardConstants.CardType.CHARACTER:
			await apply((selected as CardCharacterData).character_type, target)
		target.discard_from_hand(selected)
		deck.discard_card(selected)
		target.update_ui()

func _nosey(player):
	print("Nosey: steal a card from the player on the left")
	var i = players.find(player)
	var target = players[(i - 1 + players.size()) % players.size()]
	if target.hand.is_empty(): 
		print("%s tried to steal from %s, but their hand is empty" % [player.player_name, target.player_name])
		return
	
	var stolen = target.hand.pick_random()
	target.hand.erase(stolen)
	player.hand.append(stolen)
	print("%s stole a card from %s!" % [player.player_name, target.player_name])
	
	target.update_ui()
	player.update_ui()
	await _enforce_hand_limit(player)

func _theater_kid(player):
	print("Theater Kid: force the player on the left to discard two cards")
	var i = players.find(player)
	var target = players[(i + 2) % players.size()]
	if target.hand.is_empty(): 
		print("%s tried to discard 2 cards but %s has no cards" % [player.player_name, target.player_name])
		return
	
	print("%s forces %s to discard 2 cards" % [player.player_name, target.player_name])
	
	target.update_ui()
	if target is AIPlayer:
		for j in 2:
			if target.hand.is_empty(): break
			var discard = target.pick_discard_card()
			target.call_deferred("emit_signal", "action_requested", discard)
			var selected: CardData = await target.action_requested
			if selected:
				if selected.card_type == CardConstants.CardType.CHARACTER:
					await apply((selected as CardCharacterData).character_type, target)
				target.discard_from_hand(selected)
				deck.discard_card(selected)
				target.update_ui()
	else:
		await _force_human_discard(target, 2)
	await _enforce_hand_limit(target)

func _class_president():
	print("Class President: All players give one card to the player on their right")
	for i in range(players.size()):
		var from_player = players[i]
		var to_player = players[(i + 1) % players.size()]
		if from_player.hand.is_empty(): 
			print("%s has no cards to give." % from_player.player_name)
			continue
			
		print("%s must give a card to %s" % [from_player.player_name, to_player.player_name])
			
		var card: CardData = from_player.pick_discard_card() if from_player is AIPlayer else await from_player.action_requested
		if not card: 
			print("No card selected from %s" % from_player.player_name)
			continue
			
		from_player.discard_from_hand(card)
		to_player.add_card_to_hand(card)
		print("%s gave a card to %s" % [from_player.player_name, to_player.player_name])
		
		from_player.update_ui()
		to_player.update_ui()
		if card.card_type == CardConstants.CardType.CHARACTER:
			await apply((card as CardCharacterData).character_type, to_player)
		await _enforce_hand_limit(to_player)

func _art_teacher():
	print("Art Teacher: All players give 2 cards to the player on their right")
	for i in range(players.size()):
		var from_player = players[i]
		var to_player = players[(i + 1) % players.size()]
		if from_player.hand.is_empty(): 
			print("%s has no cards to give." % from_player.player_name)
			continue
		
		var num = min(2, from_player.hand.size())
		print("%s must give %d card(s) to %s" % [from_player.player_name, num, to_player.player_name])
		
		var cards = []
		if from_player is AIPlayer:
			for j in num:
				cards.append(from_player.pick_discard_card())
		else:
			for j in num:
				if from_player.hand.is_empty(): break
				var c: CardData = await from_player.action_requested
				if c: cards.append(c)
		for card in cards:
			from_player.discard_from_hand(card)
			to_player.add_card_to_hand(card)
			print("%s gave card to %s" % [from_player.player_name, to_player.player_name])
			
			if card.card_type == CardConstants.CardType.CHARACTER:
				await apply((card as CardCharacterData).character_type, to_player)
		from_player.update_ui()
		to_player.update_ui()
		await _enforce_hand_limit(to_player)

func _bad_boy():
	print("Bad Boy: All players discard one random card")
	for p in players:
		if p.hand.is_empty(): 
			print("%s has no cards to discard." % p.player_name)
			continue
		
		print("Prompting %s to discard a random card" % p.player_name)
		var card: CardData = p.hand[randi() % p.hand.size()] if p is AIPlayer else _discard_random_card_from_player(p)
		p.discard_from_hand(card)
		deck.discard_card(card)
		print("%s discarded %s" % [p.player_name, card.card_name])
		
		if card.card_type == CardConstants.CardType.CHARACTER:
			await apply((card as CardCharacterData).character_type, p)
		p.update_ui()
		await _enforce_hand_limit(p)

func _history_teacher():
	print("History Teacher: All players discard 2 cards")
	for p in players:
		if p.hand.is_empty(): 
			print("%s has no cards." % p.player_name)
			continue
			
		var num = min(2, p.hand.size())
		if p is AIPlayer:
			for i in num:
				var card = p.pick_discard_card()
				p.discard_from_hand(card)
				deck.discard_card(card)
				print("%s discarded %s" % [p.player_name, card.card_name])
				
				if card.card_type == CardConstants.CardType.CHARACTER:
					await apply((card as CardCharacterData).character_type, p)
		else:
			print("%s must discard %d card(s)" % [p.player_name, num])
			for i in num:
				if p.hand.is_empty(): break
				var selected: CardData = await p.action_requested
				if selected:
					p.discard_from_hand(selected)
					deck.discard_card(selected)
					print("%s discarded %s" % [p.player_name, selected.card_name])
					
					if selected.card_type == CardConstants.CardType.CHARACTER:
						await apply((selected as CardCharacterData).character_type, p)
		p.update_ui()
		await _enforce_hand_limit(p)

# === SHARED HELPERS ===

func _enforce_hand_limit(player: BasePlayer):
	while player.hand.size() > 7:
		print("%s has too many cards. Forcing discard..." % player.player_name)
		player.update_ui()
		if player is AIPlayer:
			var discard = player.pick_discard_card()
			player.emit_signal("action_requested", discard)
		var selected: CardData = await player.action_requested
		if selected:
			if selected.card_type == CardConstants.CardType.CHARACTER:
				await apply((selected as CardCharacterData).character_type, player)
			player.discard_from_hand(selected)
			deck.discard_card(selected)
			player.update_ui()

func _force_human_discard(player: Player, count: int):
	for i in count:
		if player.hand.is_empty(): break
		var card: CardData = await player.action_requested
		if not card: break
		player.discard_from_hand(card)
		deck.discard_card(card)
		player.update_ui()
		if card.card_type == CardConstants.CardType.CHARACTER:
			await apply((card as CardCharacterData).character_type, player)

func _discard_random_card_from_player(player: BasePlayer) -> CardData:
	return player.hand[randi() % player.hand.size()]
