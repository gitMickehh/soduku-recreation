class_name Input_Line_Manager extends VBoxContainer


signal new_input_chosen(new_input: int)

func _ready() -> void:
	var children = get_children()
	for child in children:
		if child is Button:
			child.connect("pressed", func ():
				new_input_chosen.emit(int(child.text))
			)
		else:
			var childrens_children = child.get_children()
			for child_2 in childrens_children:
				if child_2 is Button:
					child_2.connect("pressed", func ():
						new_input_chosen.emit(int(child_2.text))
					)
