extends Card
class_name CardJoker

func setup_card(color: CardConstants.CardColor):
	card_type = CardConstants.CardType.JOKER
	card_texture = CardAssetsUtils.get_joker_card_texture()
