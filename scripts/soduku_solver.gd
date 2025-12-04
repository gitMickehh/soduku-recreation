class_name Soduku_Solver extends Node

func _init() -> void:
	pass

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

func _get_line_from_point(point: Vector2i, block_point: Vector2i, horizontal: bool, game_array) -> Array[int]:
	var block_vectors_to_check 
	
	if horizontal: block_vectors_to_check = _get_horizontal_neighbor_block_vectors(point)
	else: block_vectors_to_check = _get_vertical_neighbor_block_vectors(point)
	
	var return_array: Array[int] = []
	
	var point_index = get_index_from_vector(point)
	
	for block_vector in block_vectors_to_check:
		if horizontal:
			return_array.append_array(
				_get_horizontal_line_in_block(point.x, game_array[get_index_from_vector(block_vector)])
			)
		else:
			return_array.append_array(
				_get_vertical_line_in_block(point.y, game_array[get_index_from_vector(block_vector)])
			)
	
	return return_array

func get_instances_indexes_in_block(number: int, block: Array[int]) -> Array[int]:
	var index: int = 0
	var ret_array: Array[int] = []
	for cell in block:
		if cell == number:
			ret_array.append(index)
		index = index + 1
	return ret_array

func get_vector_from_index(index: int) -> Vector2i:
	return Vector2i(floori(index / 3),index % 3)

func get_index_from_vector(vector: Vector2i) -> int:
	return ((vector.x * 3) + vector.y)
