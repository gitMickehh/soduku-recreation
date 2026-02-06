class_name Button_Logic extends Button

var cell_data: CellData = CellData.new()
signal pressed_with_info(button: Button_Logic)
var stylebox_theme: StyleBoxFlat

var filled: bool = false

@export var default_color_stylebox: StyleBox
@export var default_color_disabled_stylebox: StyleBox
@export var duplicate_color_stylebox: StyleBox
@export var duplicate_color_disabled_stylebox: StyleBox

@onready var hints_container: VBoxContainer = $hints_container
@onready var hint_label_1: Label = $"hints_container/line-1/hint-label-1"
@onready var hint_label_2: Label = $"hints_container/line-1/hint-label-2"
@onready var hint_label_3: Label = $"hints_container/line-1/hint-label-3"
@onready var hint_label_4: Label = $"hints_container/line-2/hint-label-4"
@onready var hint_label_5: Label = $"hints_container/line-2/hint-label-5"
@onready var hint_label_6: Label = $"hints_container/line-2/hint-label-6"
@onready var hint_label_7: Label = $"hints_container/line-3/hint-label-7"
@onready var hint_label_8: Label = $"hints_container/line-3/hint-label-8"
@onready var hint_label_9: Label = $"hints_container/line-3/hint-label-9"


func _ready() -> void:
	connect("pressed", func():
		pressed_with_info.emit(self)
	)

#func set_index_id(index_id: int, block_vector: Vector2i) -> void:
func set_index_id(index_vector: Vector2i, block_vector: Vector2i) -> void:
	cell_data.cell_location.location_vector = index_vector
	cell_data.cell_location.parent_block_vector = block_vector

func set_selected(selected: bool) -> void:
	disabled = selected
	#if selected:
		#toggle_hints(false)

func toggle_hints(toggleHints: bool) -> void:
	hints_container.visible = toggleHints

func get_hints_status() -> bool:
	return hints_container.visible

func set_number_text(number: int) -> void:
	cell_data.content = number
	if number == 0: 
		text = ""
		set_filled(false)
	else:
		text = str(number)
		set_filled(true)

func set_filled(fill: bool) -> void:
	filled = fill
	toggle_hints(!filled)

func number_is_equal(number: int) -> bool:
	return number == cell_data.content

func default_color() -> void:
	update_button_styleboxes(default_color_stylebox, default_color_disabled_stylebox)

func mistake_color() -> void:
	update_button_styleboxes(duplicate_color_stylebox, duplicate_color_disabled_stylebox)

func update_button_styleboxes(normal: StyleBox, disabled_box: StyleBox) -> void:
	remove_theme_stylebox_override("disabled")
	remove_theme_stylebox_override("hover")
	remove_theme_stylebox_override("normal")
	add_theme_stylebox_override("normal", normal)
	add_theme_stylebox_override("disabled", disabled_box)
	add_theme_stylebox_override("pressed", disabled_box)
	add_theme_stylebox_override("hover", disabled_box)

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
