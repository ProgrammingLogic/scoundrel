class_name CardFrontLayout extends CardLayout

@onready var card_background: Panel = %CardBackground
@onready var card_value: Label = %CardValue
@onready var card_suite: Label = %CardSuite


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


## Show the selection indicator for the card layout.
func select():
	var selected_indicator_size: Vector2 = Globals.selected_indicator.size
	var center = size
	var bottom_center = Vector2(center.x, center.y + size.y)

	# Scaling by the selected indicator's size Y was required for it to show at
	#	the bottom of the card, I have no idea why.
	var global_bottom_center = Vector2(
		global_position.x + size.x / 2,
		global_position.y + size.y / 2 + selected_indicator_size.y,
	)

	Globals.selected_indicator.show()
	Globals.selected_indicator.position = global_bottom_center



## Hide the selection indicator for the card layout.
func deselect():
	Globals.selected_indicator.hide()
