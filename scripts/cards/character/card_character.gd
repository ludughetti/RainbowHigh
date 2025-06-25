extends Card
class_name CardCharacter

@export var character_type: CardConstants.CardCharacter = CardConstants.CardCharacter.NONE

func set_card_data(card: CardData):
	card_data = card
	card_type = card.card_type

	if card is CardCharacterData:
		character_type = card.character_type

func set_ui_data():
	$CardButton.texture_normal = card_data.card_texture_idle
	$CardButton.texture_hover = card_data.card_texture_hover
	$CardButton.texture_pressed = card_data.card_texture_pressed
	$CardButton/Description.text = card_data.card_name
