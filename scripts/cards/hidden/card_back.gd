extends Card
class_name CardBack

@export var back_texture: Texture

func set_card_data(card: CardData):
	card_data = card
	card_type = card.card_type

func set_ui_data():
	$CardButton.texture_normal = back_texture
	$CardButton.texture_hover = back_texture
	$CardButton.texture_pressed = back_texture
