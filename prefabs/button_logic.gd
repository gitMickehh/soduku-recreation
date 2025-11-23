class_name Button_Logic extends Button

var vector_identifier: Vector2i

func set_vec_id(vec_id: Vector2i) -> void:
	vector_identifier = vec_id

func set_selected(selected: bool) -> void:
	disabled = selected
