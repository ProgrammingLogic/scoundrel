class_name CardFrontLayout extends CardLayout

func _update_display() -> void:
	var data = card_resource as ScoundrelCardResource
	assert(data)
	assert(data.suite in ["hearts", "clubs", "spades", "diamonds"])
	assert(data.value > 0)
	assert(data.value < 15)
	assert(data.card_type in ["monster", "potion", "weapon"])

	match data.card_type:
		"monster":
			%CardValue.theme_type_variation = "MonsterCard"
			%CardType.theme_type_variation = "MonsterCard"
			%CardType.text = "Monster"
		"weapon":
			%CardValue.theme_type_variation = "WeaponCard"
			%CardType.theme_type_variation = "WeaponCard"
			%CardType.text = "Weapon"
		"potion":
			%CardValue.theme_type_variation = "PotionCard"
			%CardType.theme_type_variation = "PotionCard"
			%CardType.text = "Potion"

	match data.value:
		14:
			%CardValue.text = "A"
		13:
			%CardValue.text = "K"
		12:
			%CardValue.text = "Q"
		11:
			%CardValue.text = "J"
		_:
			%CardValue.text = "%d" % [data.value]


## Show the selection indicator for the card layout.
func select():
	var selected_indicator_size: Vector2 = Globals.selected_indicator.size
	var center = size
	var bottom_center = Vector2(center.x, center.y + size.y)

	# Scaling by the selected indicator's size Y was required for it to show at
	#	the bottom of the card, I have no idea why.
	var global_bottom_center = Vector2(
		global_position.x + size.x / 2,
		global_position.y + size.y + selected_indicator_size.y / 2,
	)

	Globals.selected_indicator.show()
	Globals.selected_indicator.position = global_bottom_center


## Hide the selection indicator for the card layout.
func deselect():
	Globals.selected_indicator.hide()
