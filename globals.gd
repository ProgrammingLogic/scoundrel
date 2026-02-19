extends Node


var deck_manager: CardDeckManager
var room: CardHand

enum Cards {
	ACE = 14,
	KING = 13,
	QUEEN = 12,
	JOKER = 11,
}

signal deck_manager_setup_finished


## Setup the deck manager.
func setup_deck_manager() -> void:
	fill_deck(deck_manager.deck)
	deck_manager.setup()
	deck_manager_setup_finished.emit()


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
