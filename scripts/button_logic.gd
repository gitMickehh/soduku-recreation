class_name Button_Logic extends Button

var cell_data: CellData = CellData.new()
signal pressed_with_info(button: Button_Logic)
var stylebox_theme: StyleBoxFlat

@export var default_color_stylebox: StyleBox
@export var default_color_disabled_stylebox: StyleBox
@export var duplicate_color_stylebox: StyleBox
@export var duplicate_color_disabled_stylebox: StyleBox

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

func default_color() -> void:
	update_button_styleboxes(default_color_stylebox, default_color_disabled_stylebox)

func mistake_color() -> void:
	update_button_styleboxes(duplicate_color_stylebox, duplicate_color_disabled_stylebox)

func update_button_styleboxes(normal: StyleBox, disabled_box: StyleBox) -> void:
	remove_theme_stylebox_override("disabled")
	remove_theme_stylebox_override("normal")
	add_theme_stylebox_override("normal", normal)
	add_theme_stylebox_override("disabled", disabled_box)

#func update_button_color(color: Color) -> void:
	#stylebox_theme = get_theme_stylebox("normal").duplicate()
	#var disabled_color = Color(color).lerp(Color.GRAY, 0.5)
	#
	#_set_stylebox_color(stylebox_theme,"normal", color)
	##_set_stylebox_color(stylebox_theme,"disabled", disabled_color)

#func _set_stylebox_color(sent_stylebox_theme: StyleBoxFlat, style_box_type: String, color: Color):
	#sent_stylebox_theme.bg_color = color
	#sent_stylebox_theme.border_color = color
	#add_theme_stylebox_override(style_box_type, sent_stylebox_theme)
