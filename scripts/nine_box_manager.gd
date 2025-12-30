class_name Block_Manager extends VBoxContainer

var buttons: Array[Button_Logic]
var vector_identifier: Vector2i

func _ready() -> void:
	_get_buttons_from_childrens_children()

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

func fill_in_square(data_to_fill: Array[int], vec_id: Vector2i) -> void:
	vector_identifier = vec_id
	var index = 0
	for button in buttons:
		if data_to_fill[index] != 0:
			button.text = str(data_to_fill[index])
			button.set_selected(true)
		#button.set_index_id(index, vector_identifier)
		button.set_index_id(Soduku_Solver.get_vector_from_index(index), vector_identifier)
		index = index + 1
	#print(data_to_fill)

func connect_press(function_to_connect: Callable) -> void:
	for button in buttons:
		button.connect("pressed_with_info", function_to_connect)

func get_string() -> String:
	var buttons_str = "["
	var index = 0
	for butt in buttons:
		buttons_str = buttons_str + butt.text
		if index < buttons.size()-1:
			buttons_str = buttons_str + ", "
		index = index + 1
	buttons_str = buttons_str + "]" 
	return buttons_str
