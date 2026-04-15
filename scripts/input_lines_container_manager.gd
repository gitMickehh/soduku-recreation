class_name Input_Line_Manager extends VBoxContainer

@export var remove_styleboxGroup: Stylebox_Group
@export var candidates_view_styleboxGroup: Stylebox_Group
@export var candidate_input_mode_styleboxGroup: Stylebox_Group

@onready var toggle_candidates_mode_button: Button_Logic = $Input_Line_1/candidates_input
@onready var candidates_view_mode_button: Button_Logic = $Input_Line_2/candidates_view
@onready var remove_button: Button_Logic = $Input_Line_2/X

signal new_input_chosen(new_input: int)
signal toggle_candidate_view_signal(togglethingy: bool)
signal toggle_candidate_input_state_signal(togglethingy: bool)
signal toggle_any_candidate_view_signal(togglestate: bool)

var candidates_view_state: bool = false
var candidate_input_mode_state: bool = false

var buttons: Array[Button_Logic] = []

func _ready() -> void:
	var children = get_children()
	for child in children:
		if child is Button_Logic:
			if child.text == "f" || child.text == "X": 
				child.text = ""
				continue
			buttons.append(child)
			child.connect("pressed", func ():
				_on_input_button_pressed(child)
			)
			
			toggle_candidate_input_state_signal.connect(child.candidate_input_mode)
			
		else:
			var childrens_children = child.get_children()
			for child_2 in childrens_children:
				if child_2 is Button_Logic:
					if child_2.text == "f" || child_2.text == "X": 
						child_2.text = ""
						continue
					buttons.append(child_2)
					child_2.connect("pressed", func ():
						_on_input_button_pressed(child_2)
					)
					
					toggle_candidate_input_state_signal.connect(child_2.candidate_input_mode)
	
	_update_buttons_colors()
	
	#toggle candidates button stuff
	candidates_view_state = false
	candidates_view_mode_button.connect("pressed", _toggle_candidates_view_button_pressed)
	
	candidate_input_mode_state = false
	toggle_candidates_mode_button.connect("pressed", _toggle_candidate_input_mode_button_pressed)

#actions
func _on_input_button_pressed(button: Button_Logic) -> void:
		new_input_chosen.emit(int(button.text))
		_set_selected(button)

func _toggle_candidates_view_button_pressed() -> void:
	candidates_view_state = !candidates_view_state
	
	if candidate_input_mode_state:
		candidate_input_mode_state = false
		_toggle_candidates_mode_button_visual_update() 
		toggle_candidate_input_state_signal.emit(candidate_input_mode_state)
	
	_toggle_candidates_view_button_visual_update()
	toggle_candidate_view_signal.emit(candidates_view_state)
	toggle_any_candidate_view_signal.emit(candidates_on())

func _toggle_candidate_input_mode_button_pressed() -> void:
	candidate_input_mode_state = !candidate_input_mode_state
	
	if candidates_view_state:
		candidates_view_state = false
		_toggle_candidates_view_button_visual_update() 
		toggle_candidate_view_signal.emit(candidates_view_state)
	
	_toggle_candidates_mode_button_visual_update()
	toggle_candidate_input_state_signal.emit(candidate_input_mode_state)
	toggle_any_candidate_view_signal.emit(candidates_on())

#listeners
func _set_selected(selected_button: Button_Logic) -> void:
	for button in buttons:
		if selected_button == button:
			button.set_state(button.BUTTON_STATE.INPUT_SELECTED)
		else:
			button.set_state(button.BUTTON_STATE.DEFAULT)

func _toggle_candidates_view_button_visual_update() -> void:
	if candidates_view_state:
		candidates_view_mode_button.update_button_styleboxes(candidates_view_styleboxGroup.disabled_stylebox, candidates_view_styleboxGroup.normal_stylebox, candidates_view_styleboxGroup.normal_stylebox)
	else:
		candidates_view_mode_button.update_button_styleboxes(candidates_view_styleboxGroup.normal_stylebox, candidates_view_styleboxGroup.disabled_stylebox, candidates_view_styleboxGroup.disabled_stylebox)
		
	candidates_view_mode_button.release_focus()

func _toggle_candidates_mode_button_visual_update() -> void:
	if candidate_input_mode_state:
		toggle_candidates_mode_button.update_button_styleboxes(candidate_input_mode_styleboxGroup.disabled_stylebox, candidate_input_mode_styleboxGroup.normal_stylebox, candidate_input_mode_styleboxGroup.normal_stylebox)
	else:
		toggle_candidates_mode_button.update_button_styleboxes(candidate_input_mode_styleboxGroup.normal_stylebox, candidate_input_mode_styleboxGroup.disabled_stylebox, candidate_input_mode_styleboxGroup.disabled_stylebox)
	
	toggle_candidates_mode_button.release_focus()

#utility
func candidates_on() -> bool:
	return candidates_view_state || candidate_input_mode_state

func _update_buttons_colors() -> void:
	for button in buttons:
		button.default_color()
		button._toggle_hints(false)
	
	remove_button.text = ""
	remove_button.update_button_look(remove_styleboxGroup)
	remove_button.connect("pressed", func ():
		_on_input_button_pressed(remove_button)
	)
	
	toggle_candidates_mode_button.update_button_look(candidate_input_mode_styleboxGroup)
	toggle_candidates_mode_button._toggle_hints(false)
	
	candidates_view_mode_button._toggle_hints(false)
	_toggle_candidates_view_button_visual_update()
	toggle_candidate_view_signal.emit(candidates_view_state)
