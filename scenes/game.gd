extends Control

var equipped_weapon: Card:
	set(card):
		equipped_weapon = card

		if card == null:
			%EquippedWeaponLabel.text = "Equipped weapon: None"
			return

		var card_data := card.card_data
		%EquippedWeaponLabel.text = "Equipped weapon: suite=%s, value=%d" %\
			[card_data.suite, card_data.value]
var max_health: int:
	set(new_max_health):
		assert(new_max_health > 0)
		max_health = new_max_health
		max_health_changed.emit(new_max_health)
		%MaxHealthLabel.text = "Max health: %s" % max_health
var health: int:
	set(new_health):
		var clamped_health = new_health if new_health < max_health else max_health
		assert(clamped_health <= max_health)

		health = clamped_health
		health_changed.emit(clamped_health)
		%HealthLabel.text = "Current health: %s" % health
var cards_played := 0: # Number of cards played in a room
	set(value):
		cards_played = value
		%CardsPlayedLabel.text = "Cards played: %d" % cards_played
var rooms_completed := 0:
	set(value):
		rooms_completed = value
		%RoomsCompletedLabel.text = "Rooms completed: %d" % rooms_completed
var health_potion_used := false: # Whether or not a health potion has been used in this room.
	set(value):
		health_potion_used = value
		%HealthPotionUsedLabel.text = "Health potion used: %s" % health_potion_used
var rooms_since_last_avoid = 0: # The number of rooms since we last avoided a room.
	set(value):
		rooms_since_last_avoid = value
		%RoomsSinceLastAvoidLabel.text = "Rooms since last avoid: %d" % rooms_since_last_avoid
var rooms_avoided = 0:
	set(value):
		rooms_avoided = value
		%RoomsAvoidedLabel.text = "Rooms avoided: %d" % rooms_avoided

@onready var deck_manager: CardDeckManager = $CardDeckManager
@onready var deck: CardPile = %Deck
@onready var room: CardRoom = %Room
@onready var discard: CardPile = %Discard
@onready var equip_button: Button = %EquipButton
@onready var potion_button: Button = %PotionButton
@onready var fight_fists_button: Button = %FightFistsWeapon
@onready var fight_weapon_button: Button = %FightWeaponButton
@onready var avoid_room_button: Button = %AvoidRoomButton
@onready var health_text: Label = %HealthText
@onready var health_bar: ProgressBar = %HealthBar

signal game_over # Emiited with argument reason: String.
signal health_changed # Emitted with argument new_value: int.
signal max_health_changed # Emitted with argument new_max: int.
signal weapon_equipped # Emitted with argument new_weapon: Card.
signal card_played # Emitted with argumwnt card: Card.
signal room_completed


func _ready() -> void:
	room.card_selected.connect(_on_card_selected)
	health_changed.connect(_on_health_changed)
	max_health_changed.connect(_on_max_health_changed)
	card_played.connect(_on_card_played)
	room_completed.connect(_on_room_completed)
	game_over.connect(_on_game_over)

	fight_fists_button.pressed.connect(_on_fight_fists_button_pressed)
	potion_button.pressed.connect(_on_potion_button_pressed)
	avoid_room_button.pressed.connect(_on_avoid_room_button_pressed)

	%RestartGameButton.pressed.connect(restart_game)

	room.card_added.connect(func(card: Card, index: int): %RoomCardCountLabel.text = "Room card count: %d" % room.get_card_count())
	room.card_removed.connect(func(card: Card, index: int): %RoomCardCountLabel.text = "Room card count: %d" % room.get_card_count())


	CG.def_front_layout = LayoutID.CARD_FRONT
	CG.def_back_layout = LayoutID.CARD_BACK

	Globals.game = self
	Globals.deck_manager = deck_manager
	Globals.deck = deck

	deck_manager.deck = create_deck()
	deck_manager.starting_pile = deck
	deck_manager.setup()

	start_game()


func start_game() -> void:
	rooms_completed = 0
	rooms_avoided = 0
	cards_played = 0
	max_health = 20
	health = max_health
	rooms_since_last_avoid = 0
	deck.shuffle()
	fill_room()
	%CardArea.show()
	%Buttons.show()
	%GameOverScreen.hide()


func restart_game() -> void:
	print("restarting game")
	while room.get_card_count() != 0:
		var card = room.get_card(0)
		room.remove_card(card)
		deck.add_card(card)

	#var room_cards = room.cards
	#deck.add_cards(room_cards)
	while discard.get_card_count() != 0:
		var card = discard.draw_card()
		deck.add_card(card)

	start_game()


## Populate the room with cards.
func fill_room() -> void:
	cards_played = 0
	health_potion_used = false

	if room.max_hand_size - room.get_card_count() > deck.get_card_count():
		game_over.emit("deck_empty")
		return

	while room.get_card_count() < room.max_hand_size:
		assert(not deck.get_card_count() == 0)
		var card = deck.draw_card()
		room.add_card(card)

		if not card.is_front_face:
			card.flip()


## Create the Scoundral card deck.
##
## Scoundrel's standard deck format:
## - Remove all red face cards & aces
## - Remove any Jokers
##
## Input:
## - None
##
## Output:
## - deck: CardDeck -> The card deck to be used by the game.
func create_deck() -> CardDeck:
	var _deck: CardDeck = CardDeck.new()
	var suites = ["hearts", "diamonds", "clubs", "spades"]
	var values = [2, 3, 4, 5, 6, 7, 8, 9, 10,
		Globals.Cards.JOKER, Globals.Cards.QUEEN,
		Globals.Cards.KING, Globals.Cards.ACE]

	for suite in suites:
		for value in values:
			if suite in ["hearts", "diamonds"] and value > 10:
				continue

			var card_data = ScoundrelCardResource.new()
			card_data.value = value
			card_data.suite = suite

			match suite:
				"hearts":
					card_data.card_type = "potion"
				"diamonds":
					card_data.card_type = "weapon"
				"spades", "clubs":
					card_data.card_type = "monster"

			_deck.cards.append(card_data)

	return _deck


func _input(event: InputEvent) -> void:
	if event.is_action('restart'):
		restart_game()


func _on_card_selected(card: Card) -> void:
	var card_data = card.card_data as ScoundrelCardResource

	match card_data.card_type:
		"monster":
			fight_fists_button.show()

			if equipped_weapon != null:
				fight_weapon_button.show()
			else:
				fight_weapon_button.hide()

			equip_button.hide()
			potion_button.hide()

		"weapon":
			equip_button.show()

			potion_button.hide()
			fight_fists_button.hide()
			fight_weapon_button.hide()
		"potion":
			potion_button.show()

			equip_button.hide()
			fight_fists_button.hide()
			fight_weapon_button.hide()


func _on_health_changed(new_health: int) -> void:
	assert(new_health <= max_health)
	assert(max_health >= 0)

	health_bar.value = new_health
	health_text.text = "%d/%d" % [new_health, max_health]


func _on_max_health_changed(new_max_health: int) -> void:
	assert(new_max_health >= 0)

	health_bar.max_value = new_max_health
	health_text.text = "%d/%d" % [health, new_max_health]

	if health > max_health:
		health = max_health


func _on_card_played(card: Card) -> void:
	if health <= 0:
		game_over.emit("negative_health")
		return

	cards_played += 1
	if room.get_card_count() <= 1:
		room_completed.emit()


func _on_room_completed() -> void:
	rooms_completed += 1
	rooms_since_last_avoid += 1
	fill_room()


func _on_fight_fists_button_pressed() -> void:
	var selected_card := room.selected_card

	if selected_card == null:
		return

	var card_data := selected_card.card_data as ScoundrelCardResource
	assert(card_data.card_type == "monster")

	health = health - card_data.value
	discard.add_card(selected_card)
	card_played.emit(selected_card)


func _on_potion_button_pressed() -> void:
	var selected_card := room.selected_card

	if selected_card == null:
		return

	var card_data := selected_card.card_data as ScoundrelCardResource
	assert(card_data.card_type == "potion")

	if not health_potion_used:
		health_potion_used = true
		health = health + card_data.value

	discard.add_card(selected_card)
	card_played.emit(selected_card)


func _on_avoid_room_button_pressed() -> void:
	if rooms_since_last_avoid < 0:
		return

	if cards_played > 0:
		return

	rooms_since_last_avoid = -1

	assert(room.get_card_count() == 4)

	while room.get_card_count() > 0:
		var card = room.get_card(0)
		var deck_size = deck.get_card_count()
		deck.add_card_at(card, deck_size - 1)

	rooms_avoided += 1
	fill_room()


func _on_game_over(reason: String):
	%GameOverScreen.show()
	%CardArea.hide()
	%Buttons.hide()

	match reason:
		"negative_health":
			%ReasonLabel.text = "You took too much damage"
		"deck_empty":
			%ReasonLabel.text = "Your deck is empty! You won!"
