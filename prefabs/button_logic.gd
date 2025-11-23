class_name Button_Logic extends Button

var index_identifier: int
var parent_block_id: Vector2i

func set_index_id(index_id: int, block_id: Vector2i) -> void:
	index_identifier = index_id
	parent_block_id = block_id

func set_selected(selected: bool) -> void:
	disabled = selected
