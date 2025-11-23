class_name Nine_Box_Manager extends VBoxContainer

var buttons: Array[Button_Logic]

func _ready() -> void:
	_get_buttons_from_childrens_children()
	#_debug_buttons_order()

func _get_buttons_from_childrens_children() -> void:
	var children = get_children()
	for child in children:
		if child is Button_Logic:
			buttons.append(child)
		else:
			var childrens_children = child.get_children()
			for child_2 in childrens_children:
				if child_2 is Button_Logic:
					buttons.append(child_2)

func _debug_buttons_order() -> void:
	var count = 1
	for button in buttons:
		button.text = str(count)
		count = count + 1

func fill_in_square(data_to_fill: Array[int]) -> void:
	var index = 0
	for button in buttons:
		if data_to_fill[index] != 0:
			button.text = str(data_to_fill[index])
			button.set_selected(true)
		index = index + 1
	#print(data_to_fill)
