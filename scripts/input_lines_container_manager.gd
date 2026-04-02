class_name Input_Line_Manager extends VBoxContainer

#@export var input_color: Color = Color("#68a183")
#@export var clear_color: Color = Color("#a66068")

@export var N_remove_stylebox: StyleBox
@export var D_remove_stylebox: StyleBox

@export var N_candidates_view_stylebox: StyleBox
@export var D_candidates_view_stylebox: StyleBox

@export var N_candidate_input_mode_stylebox: StyleBox
@export var D_candidate_input_mode_stylebox: StyleBox

@onready var toggle_candidates_mode_button: Button_Logic = $Input_Line_1/candidates_input
@onready var candidates_view_mode_button: Button_Logic = $Input_Line_2/candidates_view

signal new_input_chosen(new_input: int)
signal toggle_candidate_view_signal(togglethingy: bool)

var toggle_candidates_view_state: bool = false
var buttons: Array[Button_Logic] = []

func _ready() -> void:
	var children = get_children()
	for child in children:
		if child is Button_Logic:
			if child.text == "f": 
				child.text = ""
				continue
			buttons.append(child)
			child.connect("pressed", func ():
				_on_input_button_pressed(child)
			)
		else:
			var childrens_children = child.get_children()
			for child_2 in childrens_children:
				if child_2 is Button_Logic:
					if child_2.text == "f": 
						child_2.text = ""
						continue
					buttons.append(child_2)
					child_2.connect("pressed", func ():
						_on_input_button_pressed(child_2)
					)
	
	_update_buttons_colors()
	
	#toggle candidates button stuff
	toggle_candidates_view_state = false
	candidates_view_mode_button.connect("pressed", _toggle_candidates_view_button_pressed)

func _on_input_button_pressed(button: Button_Logic) -> void:
		new_input_chosen.emit(int(button.text))
		_set_selected(button)

func _set_selected(selected_button: Button_Logic) -> void:
	for button in buttons:
		button.set_selected(selected_button == button)

func _toggle_candidates_view_button_pressed() -> void:
	toggle_candidates_view_state = !toggle_candidates_view_state
	_toggle_candidates_mode_button_visual_update()
	
	toggle_candidate_view_signal.emit(toggle_candidates_view_state)

func _update_buttons_colors() -> void:
	for button in buttons:
		if button.text == "X": 
			button.update_button_styleboxes(N_remove_stylebox ,D_remove_stylebox, D_remove_stylebox)
			button.text = ""
		else:
			button.default_color()
			#button.update_button_styleboxes(N_input_stylebox ,D_input_stylebox, D_input_stylebox)
		button.toggle_hints(false)
	
	toggle_candidates_mode_button.update_button_styleboxes(N_candidate_input_mode_stylebox, D_candidate_input_mode_stylebox, D_candidate_input_mode_stylebox)
	toggle_candidates_mode_button.toggle_hints(false)
	
	candidates_view_mode_button.toggle_hints(false)
	_toggle_candidates_mode_button_visual_update()
	toggle_candidate_view_signal.emit(toggle_candidates_view_state)
	
func _toggle_candidates_mode_button_visual_update() -> void:
	if toggle_candidates_view_state:
		candidates_view_mode_button.update_button_styleboxes(D_candidates_view_stylebox, D_candidates_view_stylebox, N_candidates_view_stylebox)
	else:
		candidates_view_mode_button.update_button_styleboxes(N_candidates_view_stylebox, N_candidates_view_stylebox, D_candidates_view_stylebox)
