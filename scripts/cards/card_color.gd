extends Card
class_name CardColor

@export var card_color: CardConstants.CardColor

func setup_card(color: CardConstants.CardColor):
	# Setup card info
	card_type = CardConstants.CardType.COLOR
	card_name = CardConstants.CardColor.keys()[color]
	card_color = color
	card_texture_idle = CardAssetsUtils.get_color_card_texture_idle(color)
	card_texture_hover = CardAssetsUtils.get_color_card_texture_hover(color)
	card_texture_pressed = CardAssetsUtils.get_color_card_texture_pressed(color)
	
func set_card_data(card: Card):
	card_type = card.card_type
	card_name = card.card_name
	card_texture_idle = card.card_texture_idle
	card_texture_hover = card.card_texture_hover
	card_texture_pressed = card.card_texture_pressed
	
	if card is CardColor:
		card_color = card.card_color

func set_ui_data():
	$CardButton.texture_normal = card_texture_idle
	$CardButton.texture_hover = card_texture_hover
	$CardButton.texture_pressed = card_texture_pressed
	$Description.text = card_name
