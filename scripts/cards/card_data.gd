extends Resource
class_name CardData

@export var card_name: String
@export var card_type: CardConstants.CardType
@export var card_texture_idle: Texture2D
@export var card_texture_hover: Texture2D
@export var card_texture_pressed: Texture2D

func set_card_data(_card: CardData):
	# Should be overridden in subclasses
	pass
