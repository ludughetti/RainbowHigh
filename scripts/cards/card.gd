extends Control
class_name Card

@export var card_type: CardConstants.CardType

var card_data: CardData

signal card_clicked(card: Card)

func _ready():
	set_ui_data()
	$CardButton.connect("pressed", Callable(self, "_on_button_pressed"))

func _on_button_pressed():
	emit_signal("card_clicked", card_data)

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("Card clicked!")
		emit_signal("card_clicked", self)
		
func set_card_data(_cardData: CardData):
	# Should be overridden in subclasses
	pass

func set_ui_data():
	# Should be overridden in subclasses
	pass
