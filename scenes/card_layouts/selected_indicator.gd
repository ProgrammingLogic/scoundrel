class_name SelectedIndicator extends Node2D
## Visual indicator that represents the currently selected card.
##
## Is a Node2D so it can be placed seperate from the UI (even though it is
##	placed where other UI elements are). Otherwise, containers will place
##	control nodes around it.

@onready var size = %Sprite2D.texture.get_size()
