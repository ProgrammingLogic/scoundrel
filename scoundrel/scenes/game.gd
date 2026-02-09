extends Control


func _ready() -> void:
	var card_data = preload("res://cards/card_resources/clubs_2.tres")
	var card = Card.new(card_data)
	add_child(card)
