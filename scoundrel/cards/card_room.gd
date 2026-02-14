class_name CardRoom extends CardHand

## Get minimum size of the CardRoom.
##
## Iterates through each of the cards in the hand and calculates the top left
## 	and bottom right corners of the card arrangement. It then calculates the size
## 	based on the calculated corners.
func _get_minimum_size() -> Vector2:
	var min_x := INF
	var max_x := -INF
	var min_y := INF
	var max_y := -INF

	var minimum_size := Vector2.ZERO
	var card_count := cards.size()

	for i in card_count:
		var card := cards[i]
		var card_position = _card_positions[i]
		var card_size = card.size

		var card_top_left = card_position - card_size / 2
		var card_bottom_right = card_position + card_size / 2

		if card_top_left.x < min_x:
			min_x = card_top_left.x

		if card_top_left.y < min_y:
			min_y = card_top_left.y

		if card_bottom_right.x > max_x:
			max_x = card_bottom_right.x

		if card_bottom_right.y > max_y:
			max_y = card_bottom_right.y

	var top_left_bound = Vector2(min_x, min_y)
	var bottom_right_bound = Vector2(max_x, max_y)

	minimum_size = bottom_right_bound - top_left_bound
	return minimum_size
