class_name RoomHandShape extends CardHandShape
## A custom hand shape for Scoundrel's rooms.

@export var horizontal_margin: int

const NUM_OF_COLUMNS = 4

func arrange_cards(cards: Array[Card], hand: CardHand, skipped_cards: Array[Card] = []) -> Array[Vector2]:
	var card_count = cards.size()
	var card_positions: Array[Vector2] = []
	var card_size_x = cards[0].size.x

	if card_count == 0:
		return []

	var actual_columns = ceili(float(card_count) / float(NUM_OF_COLUMNS))
	var grid_starting_position = Vector2(0, 0)

	var width = (actual_columns - 1)
	var height = (cards[0].size.y)

	for i: int in card_count:
		var card := cards[i]
		var grid_index = i / actual_columns
		var offset_x = grid_index * (card_size_x + horizontal_margin)

		var card_position = Vector2(
			grid_starting_position.x + offset_x,
			grid_starting_position.y,
		)

		card_positions.append(card_position)

		if not skipped_cards.is_empty() and skipped_cards.has(card):
			continue

		var card_global_position = hand.global_position + card_position
		card.tween_position(card_global_position, 0.2, true)
		card.rotation = card.rotation_offset

	return card_positions
