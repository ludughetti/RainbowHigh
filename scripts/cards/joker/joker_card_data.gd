extends CardData
class_name CardJokerData

func setup_card():
	card_type = CardConstants.CardType.JOKER
	card_name = CardConstants.CardType.keys()[card_type]
	card_texture_idle = CardAssetsUtils.get_joker_card_texture_idle()
	card_texture_hover = CardAssetsUtils.get_joker_card_texture_hover()
	card_texture_pressed = CardAssetsUtils.get_joker_card_texture_pressed()

func set_card_data(card: CardData):
	card_type = card.card_type
	card_name = card.card_name
	card_texture_idle = card.card_texture_idle
	card_texture_hover = card.card_texture_hover
	card_texture_pressed = card.card_texture_pressed
