extends Control

@onready var play_button = $PlayButton
@onready var quit_button = $QuitButton

func _ready():
	play_button.pressed.connect(_on_play_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/game/game.tscn") # Replace with your game scene path

func _on_quit_pressed():
	get_tree().quit()
