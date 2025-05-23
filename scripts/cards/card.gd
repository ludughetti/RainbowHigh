extends Control
class_name Card

const CardConstants = preload("res://scripts/utils/card_constants.gd")

@export var card_name: String
@export var card_type: CardConstants.CardType
@export var card_texture: Texture2D

signal card_clicked(card: Card)

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("Card clicked!")
		emit_signal("card_clicked", self)
