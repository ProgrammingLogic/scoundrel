extends Control


@onready var cards: Array[Card]
@onready var room_hand: CardHand = %CardRoom
@onready var deck_button: Card = %DeckButton
@onready var card_deck_manager: CardDeckManager = %CardDeckManager


enum Cards {
	ACE = 14,
	KING = 13,
	QUEEN = 12,
	JOKER = 11,
}


func _ready() -> void:
	CG.def_front_layout = LayoutID.CARD_FRONT
	CG.def_back_layout = LayoutID.CARD_BACK

	deck_button.flip()
	fill_deck(card_deck_manager.deck)
	card_deck_manager.setup()
	fill_room()


## Fills the deck according to Scoundral's standard deck format.
##
## Scoundrel's standard deck format:
## - Remove all red face cards & aces
## - Remove any Jokers
##
## Input:
## - deck: CardDeck -> The deck to setup.
##
## Output:
## - None
func fill_deck(deck: CardDeck) -> void:
	var suites = ["hearts", "diamonds", "clubs", "spades"]
	var values = [2, 3, 4, 5, 6, 7, 8, 9, 10,
		Cards.JOKER, Cards.QUEEN, Cards.KING, Cards.ACE]

	for suite in suites:
		for value in values:
			if suite in ["hearts", "diamonds"] and value > 10:
				continue

			var card = ScoundrelCardResource.new()
			card.value = value
			card.suite = suite

			deck.add_card(card)


## Fills the room with cards from the deck.
func fill_room() -> void:
	var to_draw: int = room_hand.get_remaining_space()
	assert(to_draw > 0)

	var deck_size = card_deck_manager.get_pile_size(CardDeck.Pile.DRAW)

	var cards = card_deck_manager.draw_cards(to_draw)
	for card in cards:
		room_hand.add_card(card)
		card.flip()
