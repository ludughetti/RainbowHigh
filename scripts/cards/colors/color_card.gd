extends CardSimple
class_name ColorCard

@export var card_color: CardConstants.CardColor

func _init():
	card_type = CardConstants.CardType.COLOR
