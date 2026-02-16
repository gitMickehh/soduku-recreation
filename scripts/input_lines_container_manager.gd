class_name Input_Line_Manager extends VBoxContainer

#@export var input_color: Color = Color("#68a183")
#@export var clear_color: Color = Color("#a66068")

@export var input_stylebox: StyleBox
@export var input_disabled_stylebox: StyleBox
@export var clear_stylebox: StyleBox
@export var clear_disabled_stylebox: StyleBox
@export var sight_stylebox: StyleBox
@export var sight_disabled_stylebox: StyleBox
@export var candidate_stylebox: StyleBox
@export var candidate_disabled_stylebox: StyleBox

@onready var mode_change: Button_Logic = $Input_Line_2/t
@onready var toggle_candidates: Button_Logic = $Input_Line_1/s

signal new_input_chosen(new_input: int)
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

func _on_input_button_pressed(button: Button_Logic) -> void:
		new_input_chosen.emit(int(button.text))
		_set_selected(button)

func _set_selected(selected_button: Button_Logic) -> void:
	for button in buttons:
		button.set_selected(selected_button == button)

func _update_buttons_colors() -> void:
	for button in buttons:
		if button.text == "X": 
			button.update_button_styleboxes(clear_stylebox ,clear_disabled_stylebox)
			button.text = ""
		else: 
			button.update_button_styleboxes(input_stylebox ,input_disabled_stylebox)
		button.toggle_hints(false)
	
	mode_change.update_button_styleboxes(sight_stylebox, sight_disabled_stylebox)
	toggle_candidates.update_button_styleboxes(candidate_stylebox, candidate_disabled_stylebox)
