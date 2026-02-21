extends Node


var deck_manager: CardDeckManager
var game: Control
var room: CardHand
var deck: CardPile
var selected_indicator: SelectedIndicator

enum Cards {
	ACE = 14,
	KING = 13,
	QUEEN = 12,
	JOKER = 11,
}
