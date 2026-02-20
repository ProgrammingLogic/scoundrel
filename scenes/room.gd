class_name CardRoom extends CardHand

signal card_selected


var selected_card: Card:
	set(new_card):
		if selected_card == new_card:
			return

		if selected_card != null:
			var old_card_layout = selected_card.get_layout() as CardFrontLayout
			old_card_layout.deselect()

		if new_card == null:
			selected_card = null
			return

		selected_card = new_card
		var new_card_layout = selected_card.get_layout() as CardFrontLayout
		new_card_layout.select()
		card_selected.emit(new_card)


func _handle_clicked_card(card: Card) -> void:
	assert(card.is_front_face)
	selected_card = card


func _on_card_removed(card: Card, index: int) -> void:
	if card == selected_card:
		selected_card = null
