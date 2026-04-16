class_name Button_Logic extends Button

enum BUTTON_STATE {DEFAULT, DUPLICATE, COMPLETE, HIGHLIGHTED, LOCKED, INPUT_SELECTED}

var cell_data: CellData = CellData.new()
signal pressed_with_info(button: Button_Logic)
var stylebox_theme: StyleBoxFlat

var button_state: BUTTON_STATE = BUTTON_STATE.DEFAULT
var previous_state: BUTTON_STATE = BUTTON_STATE.DEFAULT

@export var default_color_styleboxGroup: Stylebox_Group
@export var duplicate_color_styleboxGroup: Stylebox_Group
@export var complete_color_styleboxGroup: Stylebox_Group

@export var default_HL_color_styleboxGroup: Stylebox_Group
@export var duplicate_HL_color_styleboxGroup: Stylebox_Group
@export var complete_HL_color_styleboxGroup: Stylebox_Group

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

var manual_candidates: Array[int] = []

func _ready() -> void:
	_toggle_hints(false)
	connect("pressed", func():
		pressed_with_info.emit(self)
	)
	default_color()

#actions and logic
func set_index_id(index_vector: Vector2i, block_vector: Vector2i) -> void:
	cell_data.cell_location.location_vector = index_vector
	cell_data.cell_location.parent_block_vector = block_vector

#func set_selected(selected: bool) -> void:
	#disabled = selected

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

func set_manual_candidate(number: int) -> void:
	if manual_candidates.has(number):
		manual_candidates.remove_at(manual_candidates.find(number))
	else:
		manual_candidates.append(number)
	
	_show_manual_candidates()

func number_is_equal(number: int) -> bool:
	return number == cell_data.content

func connect_input_manager_singals(input_obj: Input_Line_Manager) -> void:
	#input_obj.toggle_candidate_view_signal.connect(_toggle_hints)
	input_obj.toggle_candidate_input_state_signal.connect(_switch_to_manual_candidates)
	input_obj.toggle_any_candidate_view_signal.connect(_toggle_hints)
	
	input_obj.new_input_chosen.connect(_new_input_chosen)

#signal listeners
func _new_input_chosen(new_input: int) -> void:
	if get_number() == new_input && new_input != 0:
		#print("my numebr is chosen!")
		set_state(BUTTON_STATE.HIGHLIGHTED)
	else:
		_revert_HL()

func _toggle_hints(toggleHints: bool) -> void:
	if disabled:
		hints_container.visible = false
		return
	hints_container.visible = toggleHints

func _switch_to_manual_candidates(manual_candidates_on: bool) -> void:
	if manual_candidates_on:
		_show_manual_candidates()

#button state
func set_state(new_state: BUTTON_STATE) -> void:
	previous_state = button_state
	button_state = new_state
	#print("previous state: " + str(previous_state))
	#print("after: previous state: " + str(previous_state))
	
	match button_state:
		BUTTON_STATE.DEFAULT:
			default_color()
			disabled = false
			if text != "":
				_toggle_hints(false)
		BUTTON_STATE.DUPLICATE:
			mistake_color()
		BUTTON_STATE.COMPLETE:
			complete_color()
		BUTTON_STATE.HIGHLIGHTED:
			_HL_state_look_update(previous_state)
		BUTTON_STATE.LOCKED:
			default_color()
			disabled = true
		BUTTON_STATE.INPUT_SELECTED:
			disabled = true

func _revert_HL() -> void:
	if button_state == BUTTON_STATE.HIGHLIGHTED:
		#print("reverting this button: " + text + " ps: " + str(previous_state))
		prev_state()

func _HL_state_look_update(old_state) -> void:
	match old_state:
		BUTTON_STATE.DEFAULT:
			default_color_HL()
		BUTTON_STATE.DUPLICATE:
			mistake_color_HL()
		BUTTON_STATE.COMPLETE:
			complete_color_HL()
		_:
			default_color_HL()

#button info
func is_locked() -> bool:
	return button_state == BUTTON_STATE.LOCKED

func get_number() -> int:
	return text.to_int()

func prev_state() -> void:
	set_state(previous_state)

func get_hints_status() -> bool:
	return hints_container.visible

#candidate options
func update_auto_candidate_list(list_of_non_candidates: Array[int]) -> void:
	for x in range(1,10):
		_toggle_candidate_number(x, !list_of_non_candidates.has(x))

func _toggle_candidate_number(num: int, toggle_option: bool) -> void:
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

func _show_manual_candidates() -> void:
	release_focus()
	for x in range(1,10):
		_toggle_candidate_number(x, manual_candidates.has(x))

#button look
func default_color() -> void:
	update_button_look(default_color_styleboxGroup)

func default_color_HL() -> void:
	update_button_look(default_HL_color_styleboxGroup)

func mistake_color() -> void:
	update_button_look(duplicate_color_styleboxGroup)

func mistake_color_HL() -> void:
	update_button_look(duplicate_HL_color_styleboxGroup)

func complete_color() -> void:
	update_button_look(complete_color_styleboxGroup)

func complete_color_HL() -> void:
	update_button_look(complete_HL_color_styleboxGroup)

func update_button_styleboxes(normal: StyleBox, hover: StyleBox, disabled_box: StyleBox) -> void:
	remove_theme_stylebox_override("disabled")
	remove_theme_stylebox_override("hover")
	remove_theme_stylebox_override("pressed")
	remove_theme_stylebox_override("normal")
	remove_theme_stylebox_override("focus")
	
	add_theme_stylebox_override("normal", normal)
	add_theme_stylebox_override("disabled", disabled_box)
	add_theme_stylebox_override("pressed", disabled_box)
	add_theme_stylebox_override("hover", hover)
	add_theme_stylebox_override("focus", disabled_box)

func update_button_look(stylebox_group: Stylebox_Group) -> void:
	update_button_styleboxes(stylebox_group.normal_stylebox, stylebox_group.hover_stylebox, stylebox_group.disabled_stylebox)

#input button options
func candidate_input_mode(mode_on: bool) -> void:
	if mode_on:
		add_theme_font_size_override("font_size", 25)
	else:
		remove_theme_font_size_override("font_size")
