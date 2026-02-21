extends PanelContainer


func _ready() -> void:
	## Setting the minimum size here allows the container to go around the the card pile.
	var mininum_size := Globals.card_size + Vector2(32, 32)
	custom_minimum_size = mininum_size
