extends VBoxContainer

var buttons: Array[Button]

func _ready() -> void:
	_get_buttons_from_childrens_children()
	_debug_buttons_order()

func _get_buttons_from_childrens_children() -> void:
	var children = get_children()
	for child in children:
		if child is Button:
			buttons.append(child)
		else:
			var childrens_children = child.get_children()
			for child_2 in childrens_children:
				if child_2 is Button:
					buttons.append(child_2)

func _debug_buttons_order() -> void:
	var count = 1
	for button in buttons:
		button.text = str(count)
		count = count + 1
