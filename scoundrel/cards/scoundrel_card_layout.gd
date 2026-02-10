extends CardLayout

@onready var texture_rect: TextureRect = %TextureRect

func _update_display() -> void:
	var data = card_resource as ScoundrelCardResource
	if not data:
		return

	texture_rect.texture = data.image
