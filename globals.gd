extends Node


var deck_manager: CardDeckManager
var game: Control
var room: CardHand
var deck: CardPile
var selected_indicator: SelectedIndicator
var card_size: Vector2 = Vector2()
var theme: Theme = preload("res://resources/game_theme.tres")

enum Cards {
	ACE = 14,
	KING = 13,
	QUEEN = 12,
	JOKER = 11,
}
