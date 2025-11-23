extends MarginContainer

var current_input: int = 0
@onready var input_lines_container: Input_Line_Manager = $Whole_Game_Container/input_lines_container

@onready var horizontal_blocks_container_1: Horizontal_Boxes_Container = $"Whole_Game_Container/Soduku_Container/horizontal_blocks_container-1"
@onready var horizontal_blocks_container_2: Horizontal_Boxes_Container = $"Whole_Game_Container/Soduku_Container/horizontal_blocks_container-2"
@onready var horizontal_blocks_container_3: Horizontal_Boxes_Container = $"Whole_Game_Container/Soduku_Container/horizontal_blocks_container-3"

var block_1: Array[int] = [8,4,0,7,0,0,0,1,0]
var block_2: Array[int] = [6,0,0,1,0,0,2,8,0]
var block_3: Array[int] = [0,7,2,5,6,0,0,0,3]
var block_4: Array[int] = [0,6,0,5,2,0,9,0,0]
var block_5: Array[int] = [0,1,0,0,0,3,0,0,6]
var block_6: Array[int] = [0,4,7,0,0,6,3,2,0]
var block_7: Array[int] = [0,0,6,4,0,7,0,3,9]
var block_8: Array[int] = [4,0,1,0,0,9,0,2,0]
var block_9: Array[int] = [7,3,0,0,0,0,6,0,4]

var game_array = [block_1, block_2, block_3, block_4, block_5, block_6, block_7, block_8, block_9]

var horizontal_boxes_containers: Array[Horizontal_Boxes_Container] = []

func _ready() -> void:
	input_lines_container.new_input_chosen.connect(_on_new_input_chosen)
	
	horizontal_boxes_containers.append(horizontal_blocks_container_1)
	horizontal_boxes_containers.append(horizontal_blocks_container_2)
	horizontal_boxes_containers.append(horizontal_blocks_container_3)
	_set_numbers(game_array)
	
	print("middle horizontal line: " + str(_get_line_from_point(Vector2i(1,1), Vector2i(1,1), true)))
	print("middle vertical line: " + str(_get_line_from_point(Vector2i(1,1), Vector2i(1,1), false)))
	
func _on_new_input_chosen(new_input: int) -> void:
	current_input = new_input
	print(current_input)

func _set_numbers(game_array) -> void:
	var index = 0
	for block_group in horizontal_boxes_containers:
		block_group.set_blocks_numbers(game_array[index], game_array[index+1],game_array[index+2])
		index = index + 3

func _check_duplicate_in_block(new_number: int, block: Array[int]) -> bool:
	return block.has(new_number)

func _get_horizontal_line_in_block(line_number: int, block:Array[int]) -> Array[int]:
	var return_array: Array[int] = []
	
	line_number = clampi(line_number,0,2)
	var starting_point = line_number * 3
	
	return_array.append(block[starting_point])
	return_array.append(block[starting_point + 1])
	return_array.append(block[starting_point + 2])
	
	return return_array

func _get_vertical_line_in_block(line_number: int, block:Array[int]) -> Array[int]:
	var return_array: Array[int] = []
	
	line_number = clampi(line_number,0,2)
	var jump = 3
	
	return_array.append(block[line_number])
	return_array.append(block[line_number + jump])
	return_array.append(block[line_number + (jump * 2)])
	
	return return_array

func _check_duplicates_horizontally() -> bool:
	
	return false

func _get_vector_from_index(index: int) -> Vector2i:
	return Vector2i(floori(index / 3),index % 3)

func _get_index_from_vector(vector: Vector2i) -> int:
	return ((vector.x * 3) + vector.y)

func _get_horizontal_neighbor_block_vectors(vector: Vector2i) -> Array[Vector2i]:
	var return_array:Array[Vector2i] = []
	
	for y in range(3):
		if y == vector.y: continue
		return_array.append(Vector2i(vector.x,y))
	
	return return_array

func _get_vertical_neighbor_block_vectors(vector: Vector2i) -> Array[Vector2i]:
	var return_array:Array[Vector2i] = []
	
	for x in range(3):
		if x == vector.x: continue
		return_array.append(Vector2i(x, vector.y))
	
	return return_array

func _get_line_from_point(point: Vector2i, block_point: Vector2i, horizontal: bool) -> Array[int]:
	var block_vectors_to_check 
	
	if horizontal: block_vectors_to_check = _get_horizontal_neighbor_block_vectors(point)
	else: block_vectors_to_check = _get_vertical_neighbor_block_vectors(point)
	
	var return_array: Array[int] = []
	
	var point_index = _get_index_from_vector(point)
	
	for block_vector in block_vectors_to_check:
		if horizontal:
			return_array.append_array(
				_get_horizontal_line_in_block(point.x, game_array[_get_index_from_vector(block_vector)])
			)
		else:
			return_array.append_array(
				_get_vertical_line_in_block(point.y, game_array[_get_index_from_vector(block_vector)])
			)
	
	return return_array
