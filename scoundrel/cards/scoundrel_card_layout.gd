extends CardLayout

@onready var name_label: Label = %NameLabel
@onready var image: TextureRect = %CardImage

func _update_display() -> void:
	var data = card_resource as ScoundrelCardResource

	if data:
		name_label.text = data.card_name
		image.texture = data.card_image
