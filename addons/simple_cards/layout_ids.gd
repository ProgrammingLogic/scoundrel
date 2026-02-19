# AUTO-GENERATED FILE - DO NOT EDIT MANUALLY
# This file is regenerated when layouts are modified in the Card Layouts panel

class_name LayoutID

const CARD_BACK: StringName = &"card_back"
const CARD_FRONT: StringName = &"card_front"
const DEFAULT: StringName = &"default"
const DEFAULT_BACK: StringName = &"default_back"
const SELECTED_CARD: StringName = &"selected_card"


## Returns all available layout IDs
static func get_all() -> Array[StringName]:
	return [
		CARD_BACK,
		CARD_FRONT,
		DEFAULT,
		DEFAULT_BACK,
		SELECTED_CARD
	]


## Check if a layout ID is valid
static func is_valid(id: StringName) -> bool:
	return id in get_all()