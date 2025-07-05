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

const CHARACTER_CARD_TEXTURES_IDLE := {
	CardConstants.CardCharacter.MATH_TEACHER: preload("res://assets/cards/character/math_teacher/MATH_TEACHER_Idle.png"),
	CardConstants.CardCharacter.SPORTSY: preload("res://assets/cards/character/sportsy/SPORTSY_Idle.png"),
	CardConstants.CardCharacter.PROM_QUEEN: preload("res://assets/cards/character/prom_queen/PROM_QUEEN_Idle.png"),
	CardConstants.CardCharacter.NOSEY: preload("res://assets/cards/character/nosey/NOSEY_Idle.png"),
	CardConstants.CardCharacter.THEATER_KID: preload("res://assets/cards/character/theater_kid/THEATER_KID_Idle.png"),
	CardConstants.CardCharacter.CLASS_PRESIDENT: preload("res://assets/cards/character/class_president/CLASS_PRESIDENT_Idle.png"),
	CardConstants.CardCharacter.ART_TEACHER: preload("res://assets/cards/character/art_teacher/ART_TEACHER_Idle.png"),
	CardConstants.CardCharacter.BAD_BOY: preload("res://assets/cards/character/bad_boy/BAD_BOY_Idle.png"),
	#CardConstants.CardCharacter.HISTORY_TEACHER: preload("res://assets/cards/character/HistoryTeacher_Idle.png")
}

const CHARACTER_CARD_TEXTURES_HOVER := {
	CardConstants.CardCharacter.MATH_TEACHER: preload("res://assets/cards/character/math_teacher/MATH_TEACHER_Hover.png"),
	CardConstants.CardCharacter.SPORTSY: preload("res://assets/cards/character/sportsy/SPORTSY_Hover.png"),
	CardConstants.CardCharacter.PROM_QUEEN: preload("res://assets/cards/character/prom_queen/PROM_QUEEN_Hover.png"),
	CardConstants.CardCharacter.NOSEY: preload("res://assets/cards/character/nosey/NOSEY_Hover.png"),
	CardConstants.CardCharacter.THEATER_KID: preload("res://assets/cards/character/theater_kid/THEATER_KID_Hover.png"),
	CardConstants.CardCharacter.CLASS_PRESIDENT: preload("res://assets/cards/character/class_president/CLASS_PRESIDENT_Hover.png"),
	CardConstants.CardCharacter.ART_TEACHER: preload("res://assets/cards/character/art_teacher/ART_TEACHER_Hover.png"),
	CardConstants.CardCharacter.BAD_BOY: preload("res://assets/cards/character/bad_boy/BAD_BOY_Hover.png"),
	#CardConstants.CardCharacter.HISTORY_TEACHER: preload("res://assets/cards/character/HistoryTeacher_Idle.png")
}

const CHARACTER_CARD_TEXTURES_PRESSED := {
	CardConstants.CardCharacter.MATH_TEACHER: preload("res://assets/cards/character/math_teacher/MATH_TEACHER_Pressed.png"),
	CardConstants.CardCharacter.SPORTSY: preload("res://assets/cards/character/sportsy/SPORTSY_Pressed.png"),
	CardConstants.CardCharacter.PROM_QUEEN: preload("res://assets/cards/character/prom_queen/PROM_QUEEN_Pressed.png"),
	CardConstants.CardCharacter.NOSEY: preload("res://assets/cards/character/nosey/NOSEY_Pressed.png"),
	CardConstants.CardCharacter.THEATER_KID: preload("res://assets/cards/character/theater_kid/THEATER_KID_Pressed.png"),
	CardConstants.CardCharacter.CLASS_PRESIDENT: preload("res://assets/cards/character/class_president/CLASS_PRESIDENT_Pressed.png"),
	CardConstants.CardCharacter.ART_TEACHER: preload("res://assets/cards/character/art_teacher/ART_TEACHER_Pressed.png"),
	CardConstants.CardCharacter.BAD_BOY: preload("res://assets/cards/character/bad_boy/BAD_BOY_Pressed.png"),
	#CardConstants.CardCharacter.HISTORY_TEACHER: preload("res://assets/cards/character/HistoryTeacher_Idle.png")
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

func get_character_card_texture_idle(character: CardConstants.CardCharacter) -> Texture2D:
	return CHARACTER_CARD_TEXTURES_IDLE.get(character, REVERSE_CARD_TEXTURE)

func get_character_card_texture_hover(character: CardConstants.CardCharacter) -> Texture2D:
	return CHARACTER_CARD_TEXTURES_HOVER.get(character, REVERSE_CARD_TEXTURE)

func get_character_card_texture_pressed(character: CardConstants.CardCharacter) -> Texture2D:
	return CHARACTER_CARD_TEXTURES_PRESSED.get(character, REVERSE_CARD_TEXTURE)
