extends Node

const ConstantsUtils = preload("res://scripts/utils/card_constants.gd")

const COLOR_CARD_TEXTURES_IDLE := {
	ConstantsUtils.CardColor.PINK: preload("res://assets/cards/core/ColorPink/PINK_Idle.png"),
	ConstantsUtils.CardColor.RED: preload("res://assets/cards/core/ColorRed/RED_Idle.png"),
	ConstantsUtils.CardColor.ORANGE: preload("res://assets/cards/core/ColorOrange/ORANGE_Idle.png"),
	ConstantsUtils.CardColor.YELLOW: preload("res://assets/cards/core/ColorYellow/YELLOW_Idle.png"),
	ConstantsUtils.CardColor.GREEN: preload("res://assets/cards/core/ColorGreen/GREEN_Idle.png"),
	ConstantsUtils.CardColor.BLUE: preload("res://assets/cards/core/ColorBlue/BLUE_Idle.png"),
	ConstantsUtils.CardColor.VIOLET: preload("res://assets/cards/core/ColorViolet/VIOLET_Idle.png")
}

const COLOR_CARD_TEXTURES_HOVER := {
	ConstantsUtils.CardColor.PINK: preload("res://assets/cards/core/ColorPink/PINK_Hover.png"),
	ConstantsUtils.CardColor.RED: preload("res://assets/cards/core/ColorRed/RED_Hover.png"),
	ConstantsUtils.CardColor.ORANGE: preload("res://assets/cards/core/ColorOrange/ORANGE_Hover.png"),
	ConstantsUtils.CardColor.YELLOW: preload("res://assets/cards/core/ColorYellow/YELLOW_Hover.png"),
	ConstantsUtils.CardColor.GREEN: preload("res://assets/cards/core/ColorGreen/GREEN_Hover.png"),
	ConstantsUtils.CardColor.BLUE: preload("res://assets/cards/core/ColorBlue/BLUE_Hover.png"),
	ConstantsUtils.CardColor.VIOLET: preload("res://assets/cards/core/ColorViolet/VIOLET_Hover.png")
}

const COLOR_CARD_TEXTURES_PRESSED := {
	ConstantsUtils.CardColor.PINK: preload("res://assets/cards/core/ColorPink/PINK_Pressed.png"),
	ConstantsUtils.CardColor.RED: preload("res://assets/cards/core/ColorRed/RED_Pressed.png"),
	ConstantsUtils.CardColor.ORANGE: preload("res://assets/cards/core/ColorOrange/ORANGE_Pressed.png"),
	ConstantsUtils.CardColor.YELLOW: preload("res://assets/cards/core/ColorYellow/YELLOW_Pressed.png"),
	ConstantsUtils.CardColor.GREEN: preload("res://assets/cards/core/ColorGreen/GREEN_Pressed.png"),
	ConstantsUtils.CardColor.BLUE: preload("res://assets/cards/core/ColorBlue/BLUE_Pressed.png"),
	ConstantsUtils.CardColor.VIOLET: preload("res://assets/cards/core/ColorViolet/VIOLET_Pressed.png")
}

const JOKER_CARD_TEXTURE_IDLE = preload("res://assets/cards/core/Joker/JOKER_Idle.png")
const JOKER_CARD_TEXTURE_HOVER = preload("res://assets/cards/core/Joker/JOKER_Idle.png")
const JOKER_CARD_TEXTURE_PRESSED = preload("res://assets/cards/core/Joker/JOKER_Idle.png")

const REVERSE_CARD_TEXTURE = preload("res://assets/cards/core/Reverse.png")

func get_color_card_texture_idle(color: CardConstants.CardColor) -> Texture2D:
	return COLOR_CARD_TEXTURES_IDLE.get(color, REVERSE_CARD_TEXTURE)
	
func get_color_card_texture_hover(color: CardConstants.CardColor) -> Texture2D:
	return COLOR_CARD_TEXTURES_HOVER.get(color, REVERSE_CARD_TEXTURE)

func get_color_card_texture_pressed(color: CardConstants.CardColor) -> Texture2D:
	return COLOR_CARD_TEXTURES_PRESSED.get(color, REVERSE_CARD_TEXTURE)

func get_joker_card_texture_idle() -> Texture2D:
	return JOKER_CARD_TEXTURE_IDLE
	
func get_joker_card_texture_hover() -> Texture2D:
	return JOKER_CARD_TEXTURE_HOVER
	
func get_joker_card_texture_pressed() -> Texture2D:
	return JOKER_CARD_TEXTURE_PRESSED
	
func get_reverse_card_texture() -> Texture2D:
	return REVERSE_CARD_TEXTURE
