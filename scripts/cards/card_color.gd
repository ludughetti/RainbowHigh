extends Card
class_name CardColor

@export var card_color: CardConstants.CardColor

func setup_card(color: CardConstants.CardColor):
	card_type = CardConstants.CardType.COLOR
	card_color = color
	card_texture = CardAssetsUtils.get_color_card_texture(color)
