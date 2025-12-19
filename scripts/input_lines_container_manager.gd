class_name Input_Line_Manager extends VBoxContainer

#@export var input_color: Color = Color("#68a183")
#@export var clear_color: Color = Color("#a66068")

@export var input_stylebox: StyleBox
@export var input_disabled_stylebox: StyleBox


signal new_input_chosen(new_input: int)
var buttons: Array[Button_Logic] = []

func _ready() -> void:
	var children = get_children()
	for child in children:
		if child is Button_Logic:
			buttons.append(child)
			child.connect("pressed", func ():
				_on_input_button_pressed(child)
			)
		else:
			var childrens_children = child.get_children()
			for child_2 in childrens_children:
				if child_2 is Button_Logic:
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
		#if button.text == "X": button.update_button_color(clear_color)
		#else: button.update_button_color(input_color)
		button.update_button_styleboxes(input_stylebox ,input_disabled_stylebox)
