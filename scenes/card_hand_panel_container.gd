extends PanelContainer


func _ready() -> void:
	## Setting the minimum size here allows the container to go around the the card pile.
	assert(%Room.shape is GridHandShape)
	var column_offset = %Room.shape.col_offset
	var row_offset = %Room.shape.row_offset

	var mininum_size := Vector2(16, 16) + Vector2(
		Globals.room_max_cards * column_offset,
		row_offset,
	)
	custom_minimum_size = mininum_size
