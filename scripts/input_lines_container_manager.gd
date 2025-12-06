class_name Input_Line_Manager extends VBoxContainer

@export var input_color: Color = Color("#68a183")
@export var clear_color: Color = Color("#a66068")

signal new_input_chosen(new_input: int)
var buttons: Array[Button_Logic] = []
var stylebox_theme: StyleBoxFlat

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
	
	stylebox_theme = buttons[0].get_theme_stylebox("normal").duplicate()
	var cancel_button_stylebox_theme = buttons[0].get_theme_stylebox("normal").duplicate()
	
	for button in buttons:
		_set_stylebox_color(button, stylebox_theme,"normal", input_color)
		if button.text == "X": _set_stylebox_color(button, cancel_button_stylebox_theme, "normal", clear_color)

func _on_input_button_pressed(button: Button_Logic) -> void:
		new_input_chosen.emit(int(button.text))
		_set_selected(button)

func _set_selected(selected_button: Button_Logic) -> void:
	for button in buttons:
		button.set_selected(selected_button == button)

func _set_stylebox_color(button: Button_Logic, sent_stylebox_theme: StyleBoxFlat, style_box_type: String, color: Color):
	sent_stylebox_theme.bg_color = color
	sent_stylebox_theme.border_color = color
	button.add_theme_stylebox_override(style_box_type, sent_stylebox_theme)
