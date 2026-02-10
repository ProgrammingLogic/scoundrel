# AUTO-GENERATED FILE - DO NOT EDIT MANUALLY
# This file is regenerated when layouts are modified in the Card Layouts panel

class_name LayoutID

const DEFAULT: StringName = &"default"
const DEFAULT_BACK: StringName = &"default_back"
const SCOUNDRAL_BACK_CARD_LAYOUT: StringName = &"scoundral_back_card_layout"
const SCOUNDREL_CARD_LAYOUT: StringName = &"scoundrel_card_layout"


## Returns all available layout IDs
static func get_all() -> Array[StringName]:
	return [
		DEFAULT,
		DEFAULT_BACK,
		SCOUNDRAL_BACK_CARD_LAYOUT,
		SCOUNDREL_CARD_LAYOUT
	]


## Check if a layout ID is valid
static func is_valid(id: StringName) -> bool:
	return id in get_all()