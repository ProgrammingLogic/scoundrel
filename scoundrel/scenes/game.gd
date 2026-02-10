extends Control


@onready var cards: Array[Card]
@onready var room: CardHand = %Room
@onready var deck: CardHand = %Deck

@onready var card_deck_manager: CardDeckManager = %CardDeckManager

signal game_won
signal game_lost


func _ready() -> void:
	CG.def_front_layout = LayoutID.DEFAULT_BACK
	CG.def_back_layout = LayoutID.SCOUNDREL_CARD_LAYOUT

	card_deck_manager.setup()
	fill_room()


## Fills the room with cards from the deck.
func fill_room() -> void:
	var to_draw: int = room.get_remaining_space()
	assert(to_draw > 0)

	var deck_size = card_deck_manager.get_pile_size(CardDeck.Pile.DRAW)

	# We've won if all of the cards in the deck have been cycled through.
	if to_draw > deck_size:
		print("we won!")
		game_won.emit(to_draw - deck_size)
		return

	room.add_cards(card_deck_manager.draw_cards(to_draw))


func create_resource_cards(image_dir: String) -> void:
	var dir := DirAccess.open(image_dir)
	assert(dir != null)

	dir.list_dir_begin()
	for file: String in dir.get_files():
		if "import" in file:
			continue
		if "back" in file:
			continue
		if "front" in file:
			continue
		if "empty" in file:
			continue

		var base_name := file.split(".")[0]
		var suite = base_name.split("_")[0]
		var value = base_name.split("_")[1]
		var image = file

		var resource = ScoundrelCardResource.new()
		resource.image = load(image)
		resource.suite = suite
		resource.value = value as int
		ResourceSaver.save(resource, "res://cards/data/%s.tres" % [base_name])


func create_resource_deck(cards_dir: String, output_file: String) -> void:
	var dir := DirAccess.open(cards_dir)
	assert(dir != null)

	var resource: CardDeck
	resource = CardDeck.new()


	dir.list_dir_begin()
	for file: String in dir.get_files():
		if "import" in file:
			continue

		var card_resource := load("res://cards/data/%s" % [file])
		resource.add_card(card_resource)

	ResourceSaver.save(resource, output_file)
