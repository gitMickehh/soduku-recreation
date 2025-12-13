class_name Button_Logic extends Button

var cell_data: CellData = CellData.new()
signal pressed_with_info(button: Button_Logic)

func _ready() -> void:
	connect("pressed", func():
		pressed_with_info.emit(self)
	)

func set_index_id(index_id: int, block_id: Vector2i) -> void:
	cell_data.cell_location.index_identifier = index_id
	cell_data.cell_location.parent_block_id = block_id

func set_selected(selected: bool) -> void:
	disabled = selected

func set_number_text(number: int) -> void:
	cell_data.content = number
	if number == 0: text = ""
	else: text = str(number)

func number_is_equal(number: int) -> bool:
	return number == cell_data.content
