extends CardHand


var selected_card: Card


func _ready() -> void:
	Globals.deck_manager_setup_finished.connect(fill_room)

	card_added.connect(_on_card_added_to_room)
	card_removed.connect(_on_card_room_card_removed)


## Fills the room with cards from the deck.
func fill_room() -> void:
	var to_draw: int = get_remaining_space()
	assert(to_draw > 0)

	var deck_size = Globals.deck_manager.get_pile_size(CardDeck.Pile.DRAW)

	var cards = Globals.deck_manager.draw_cards(to_draw)
	for card in cards:
		add_card(card)
		card.flip()


## Change the selected card.
func set_selected_card(card: Card):
	assert(card in cards)

	if selected_card != null:
		# Eventually, we will want to run other statements when removing an
		#	active card.
		selected_card = null

	selected_card = card
	card.set_layout("selected_card")


## Connects the _on_clicked funtion to the new card.
func _on_card_added_to_room(card: Card, index: int) -> void:
	if not card.card_clicked.is_connected(_on_card_in_room_clicked):
		card.card_clicked.connect(_on_card_in_room_clicked)


## Disconnects the _on_clicked funtion to the new card.
func _on_card_room_card_removed(card: Card, index: int) -> void:
	if card.card_clicked.is_connected(_on_card_in_room_clicked):
		card.card_clicked.disconnect(_on_card_in_room_clicked)


func _on_card_in_room_clicked(card: Card):
	assert(card in cards)
	print("card in room clicked")
