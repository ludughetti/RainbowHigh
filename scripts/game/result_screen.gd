extends Control

@onready var return_button = $Background/MainMenuButton

func _ready():
	return_button.pressed.connect(_on_return_pressed)
	$Background/ResultLabel.text = "%s completed the rainbow!" % Global.winner_name

func _on_return_pressed():
	get_tree().change_scene_to_file("res://scenes/game/main_menu.tscn")
