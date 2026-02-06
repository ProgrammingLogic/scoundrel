extends Node2D


@onready var card_manager = %CardManager

@onready var deck = %Deck
@onready var room = %Room
@onready var discard = %Discard


func _ready() -> void:
	start_game()


func start_game() -> void:
	create_deck()

	draw_room()


## Create the deck that is to be used for the game.
##
## Input:
## - None
##
## Output:
## - None
func create_deck() -> void:
	var suites = ["clubs", "diamonds", "hearts", "spades"]
	var values = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]

	for suite in suites:
		for value in values:
			# Remove diamond/heart A, J, Q, K from the deck
			if suite in ["diamond", "heart"] and value in ["A", "J", "Q", "K"]:
				continue

			var card_name = "%s_%s" % [suite, value]
			var card = card_manager.card_factory.create_card(card_name, deck)
			deck.add_card(card)


## Draw cards into the room.
##
## Input:
## - None
##
## Output:
## - None
func draw_room() -> void:
	var count_room_cards = room.get_card_count()
	assert(count_room_cards < 4)

	for i in 4:
		var count_deck_cards = deck.get_card_count()

		if count_deck_cards == 0:
			break

		var card = deck.get_top_cards(1).front()
		room.move_cards([card])
