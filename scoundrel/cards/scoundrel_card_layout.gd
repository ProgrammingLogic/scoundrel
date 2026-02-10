extends CardLayout

@onready var card_background: Panel = %CardBackground
@onready var card_value: Label = %CardValue
@onready var card_suite: Label = %CardSuite

func _update_display() -> void:
	var data = card_resource as ScoundrelCardResource
	assert(data)
	assert(data.suite in ["hearts", "clubs", "spades", "diamonds"])
	assert(data.value > 0)
	assert(data.value < 15)

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
