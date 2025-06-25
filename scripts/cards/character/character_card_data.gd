extends CardData
class_name CardCharacterData

@export var character_type: CardConstants.CardCharacter = CardConstants.CardCharacter.NONE

func setup_card(type: CardConstants.CardCharacter):
	card_type = CardConstants.CardType.CHARACTER
	character_type = type
	card_name = CardConstants.CardCharacter.keys()[type]
	card_texture_idle = CardAssetsUtils.get_character_card_texture_idle(type)
	card_texture_hover = CardAssetsUtils.get_character_card_texture_hover(type)
	card_texture_pressed = CardAssetsUtils.get_character_card_texture_pressed(type)

func set_card_data(card: CardData):
	card_type = card.card_type
	card_name = card.card_name
	card_texture_idle = card.card_texture_idle
	card_texture_hover = card.card_texture_hover
	card_texture_pressed = card.card_texture_pressed

	if card is CardCharacterData:
		character_type = card.character_type
