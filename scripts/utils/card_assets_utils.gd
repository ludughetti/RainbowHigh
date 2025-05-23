extends Node

const CardConstants = preload("res://scripts/utils/card_constants.gd")

const COLOR_CARD_TEXTURES := {
	CardConstants.CardColor.PINK: preload("res://assets/cards/core/Pink.png"),
	CardConstants.CardColor.RED: preload("res://assets/cards/core/Red.png"),
	CardConstants.CardColor.ORANGE: preload("res://assets/cards/core/Orange.png"),
	CardConstants.CardColor.YELLOW: preload("res://assets/cards/core/Yellow.png"),
	CardConstants.CardColor.GREEN: preload("res://assets/cards/core/Green.png"),
	CardConstants.CardColor.BLUE: preload("res://assets/cards/core/Blue.png"),
	CardConstants.CardColor.VIOLET: preload("res://assets/cards/core/Violet.png")
}

const JOKER_CARD_TEXTURE = preload("res://assets/cards/core/Joker.png")
const REVERSE_CARD_TEXTURE = preload("res://assets/cards/core/Reverse.png")

func get_color_card_texture(color: CardConstants.CardColor) -> Texture2D:
	return COLOR_CARD_TEXTURES.get(color, REVERSE_CARD_TEXTURE)

func get_joker_card_texture() -> Texture2D:
	return JOKER_CARD_TEXTURE
	
func get_reverse_card_texture() -> Texture2D:
	return REVERSE_CARD_TEXTURE
