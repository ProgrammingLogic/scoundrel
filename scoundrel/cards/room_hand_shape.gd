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

	var column_count = ceili(float(card_count) / float(NUM_OF_COLUMNS))

	var width = (column_count - 1)
	var height = (cards[0].size.y)

	for i: int in card_count:
		var card := cards[i]
		var card_size = card.size
		var grid_index = i / column_count
		var grid_offset = grid_index * (card_size_x + horizontal_margin)

		var card_position = Vector2(grid_offset, 0)
		card_positions.append(card_position)

		if not skipped_cards.is_empty() and skipped_cards.has(card):
			continue

		card.tween_position(card_position, 0.2)
		card.rotation = card.rotation_offset

	return card_positions
