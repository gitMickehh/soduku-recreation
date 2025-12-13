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

func find_duplicates_in_game_array(number: int, cell_location: CellLocation, game_array) -> Array[CellLocation]:
	var return_array:Array[CellLocation] = []
	var cell_vector = get_vector_from_index(cell_location.index_identifier)
	
	#check block
	var points_in_block = get_instances_indexes_in_block(number, game_array[get_index_from_vector(cell_location.parent_block_id)])
	for cell in points_in_block:
		return_array.append(CellLocation.new_cell(cell, cell_location.parent_block_id))
	
	if return_array.size() == 1:
		return_array.clear()
	
	#check lines
	#horizontal
	var numbers_in_horizontal_line = _get_line_from_point(cell_vector, cell_location.parent_block_id, true, game_array)
	var loop_index = 0
	for num in numbers_in_horizontal_line:
		if num == number:
			var dupe_cell_location = (loop_index % 3) + (cell_vector.y * 3)
			var location_of_neighbor_block = Vector2i(floor(loop_index/3), cell_location.parent_block_id.y)
			return_array.append(CellLocation.new_cell(dupe_cell_location, location_of_neighbor_block))
		loop_index = loop_index + 1
	
	#vertical
	var numbers_in_vertical_line = _get_line_from_point(cell_vector, cell_location.parent_block_id, false, game_array)
	loop_index = 0
	for num in numbers_in_vertical_line:
		if num == number:
			var dupe_cell_location = cell_vector.x + ((loop_index % 3) * 3)
			var location_of_neighbor_block = Vector2i(cell_location.parent_block_id.x, floor(loop_index/3))
			return_array.append(CellLocation.new_cell(dupe_cell_location, location_of_neighbor_block))
		loop_index = loop_index + 1
	
	return return_array
