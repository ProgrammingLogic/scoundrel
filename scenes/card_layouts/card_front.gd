class_name CardFrontLayout extends CardLayout

@onready var card_background: Panel = %CardBackground
@onready var card_value: Label = %CardValue
@onready var card_suite: Label = %CardSuite
@onready var card_type: Label = %CardType
@onready var selected_indicator_sprite = %Sprite2D


func _update_display() -> void:
	var data = card_resource as ScoundrelCardResource
	assert(data)
	assert(data.suite in ["hearts", "clubs", "spades", "diamonds"])
	assert(data.value > 0)
	assert(data.value < 15)
	assert(data.card_type in ["monster", "potion", "weapon"])

	match data.suite:
		"hearts":
			card_value.modulate = Color.RED
			card_suite.text = "♥️"
		"diamonds":
			card_value.modulate = Color.RED
			card_suite.text = "♦️"
		"clubs":
			card_value.modulate = Color.BLACK
			card_suite.text = "♣️"
		"spades":
			card_value.modulate = Color.BLACK
			card_suite.text = "♠️"

	match data.value:
		14:
			card_value.text = "A"
		13:
			card_value.text = "K"
		12:
			card_value.text = "Q"
		11:
			card_value.text = "J"
		_:
			card_value.text = "%d" % [data.value]

	match data.card_type:
		"weapon":
			card_type.text = "Weapon"
		"monster":
			card_type.text = "Monster"
		"potion":
			card_type.text = "Potion"


## Show the selection indicator for the card layout.
func select():
	selected_indicator_sprite.show()


## Hide the selection indicator for the card layout.
func deselect():
	selected_indicator_sprite.hide()
