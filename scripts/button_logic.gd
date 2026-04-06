class_name Button_Logic extends Button

enum BUTTON_STATE {DEFAULT, DUPLICATE, COMPLETE, HIGHLIGHTED, LOCKED, INPUT_SELECTED}

var cell_data: CellData = CellData.new()
signal pressed_with_info(button: Button_Logic)
var stylebox_theme: StyleBoxFlat

#var filled: bool = false
var button_state: BUTTON_STATE = BUTTON_STATE.DEFAULT

@export var default_color_styleboxGroup: Stylebox_Group
@export var duplicate_color_styleboxGroup: Stylebox_Group
@export var complete_color_styleboxGroup: Stylebox_Group

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
	toggle_hints(false)
	connect("pressed", func():
		pressed_with_info.emit(self)
	)
	default_color()

#func set_index_id(index_id: int, block_vector: Vector2i) -> void:
func set_index_id(index_vector: Vector2i, block_vector: Vector2i) -> void:
	cell_data.cell_location.location_vector = index_vector
	cell_data.cell_location.parent_block_vector = block_vector

#func set_selected(selected: bool) -> void:
	#disabled = selected

func toggle_hints(toggleHints: bool) -> void:
	if disabled:
		hints_container.visible = false
		return
	hints_container.visible = toggleHints

func get_hints_status() -> bool:
	return hints_container.visible

func set_number_text(number: int) -> void:
	cell_data.content = number
	if number == 0: 
		text = ""
		#set_filled(false)
		#set_state(BUTTON_STATE.DEFAULT)
	else:
		text = str(number)
		#set_state(BUTTON_STATE.DEFAULT_FILLED)
		#set_filled(true)
	set_state(BUTTON_STATE.DEFAULT)

#func set_filled(fill: bool) -> void:
	#
	#filled = fill
	#if filled:
		#toggle_hints(false)

func number_is_equal(number: int) -> bool:
	return number == cell_data.content

func default_color() -> void:
	update_button_look(default_color_styleboxGroup)

func mistake_color() -> void:
	update_button_look(duplicate_color_styleboxGroup)

func complete_color() -> void:
	update_button_look(complete_color_styleboxGroup)

func update_button_styleboxes(normal: StyleBox, hover: StyleBox, disabled_box: StyleBox) -> void:
	remove_theme_stylebox_override("disabled")
	remove_theme_stylebox_override("hover")
	remove_theme_stylebox_override("normal")
	add_theme_stylebox_override("normal", normal)
	add_theme_stylebox_override("disabled", disabled_box)
	add_theme_stylebox_override("pressed", disabled_box)
	add_theme_stylebox_override("hover", hover)

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

#func override_button_styleboxes() -> void:
	#

func connect_input_manager_singals(input_obj: Input_Line_Manager) -> void:
	input_obj.toggle_candidate_view_signal.connect(toggle_hints)
	input_obj.new_input_chosen.connect(_new_input_chosen)

func _new_input_chosen(new_input: int) -> void:
	pass

func update_auto_candidate_list(list_of_non_candidates: Array[int]) -> void:
	for x in range(1,10):
		_toggle_auto_candidate_number(x, !list_of_non_candidates.has(x))

func _toggle_auto_candidate_number(num: int, toggle_option: bool) -> void:
	match num:
		1:
			#hint_label_1.visible = toggle_option
			if toggle_option:
				hint_label_1.text = str(num)
			else:
				hint_label_1.text = " "
		2:
			if toggle_option:
				hint_label_2.text = str(num)
			else:
				hint_label_2.text = " "
		3:
			if toggle_option:
				hint_label_3.text = str(num)
			else:
				hint_label_3.text = " "
		4:
			if toggle_option:
				hint_label_4.text = str(num)
			else:
				hint_label_4.text = " "
		5:
			if toggle_option:
				hint_label_5.text = str(num)
			else:
				hint_label_5.text = " "
		6:
			if toggle_option:
				hint_label_6.text = str(num)
			else:
				hint_label_6.text = " "
		7:
			if toggle_option:
				hint_label_7.text = str(num)
			else:
				hint_label_7.text = " "
		8:
			if toggle_option:
				hint_label_8.text = str(num)
			else:
				hint_label_8.text = " "
		9:
			if toggle_option:
				hint_label_9.text = str(num)
			else:
				hint_label_9.text = " "

func set_state(new_state: BUTTON_STATE) -> void:
	var prev_state = button_state
	button_state = new_state
	
	match button_state:
		BUTTON_STATE.DEFAULT:
			default_color()
			disabled = false
			if text != "":
				toggle_hints(false)
		BUTTON_STATE.DUPLICATE:
			mistake_color()
		BUTTON_STATE.COMPLETE:
			complete_color()
		BUTTON_STATE.HIGHLIGHTED:
			pass
		BUTTON_STATE.LOCKED:
			disabled = true
		BUTTON_STATE.INPUT_SELECTED:
			disabled = true

func is_locked() -> bool:
	return button_state == BUTTON_STATE.LOCKED

func get_number() -> int:
	return text.to_int()

func update_button_look(stylebox_group: Stylebox_Group) -> void:
	update_button_styleboxes(stylebox_group.normal_stylebox, stylebox_group.hover_stylebox, stylebox_group.disabled_stylebox)
