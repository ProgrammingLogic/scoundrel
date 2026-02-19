extends Control


@onready var cards: Array[Card]
@onready var card_room: CardHand = %CardRoom
@onready var deck_button: Card = %DeckButton


func _ready() -> void:
	CG.def_front_layout = LayoutID.CARD_FRONT
	CG.def_back_layout = LayoutID.CARD_BACK

	Globals.deck_manager = $CardDeckManager
	Globals.setup_deck_manager()
	deck_button.flip()
