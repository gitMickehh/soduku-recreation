class_name Soduku_Solver extends Node

func _init() -> void:
	pass

func _get_horizontal_neighbor_block_vectors(block_vector: Vector2i) -> Array[Vector2i]:
	var return_array:Array[Vector2i] = []
	
	for y in range(3):
		if y == block_vector.y: continue
		return_array.append(Vector2i(block_vector.x,y))
	
	return return_array

func _get_vertical_neighbor_block_vectors(block_vector: Vector2i) -> Array[Vector2i]:
	var return_array:Array[Vector2i] = []
	
	for x in range(3):
		if x == block_vector.x: continue
		return_array.append(Vector2i(x, block_vector.y))
	
	return return_array

func _get_horizontal_line_in_block(line_number: int, block_id:Vector2i, game_array) -> Array[CellData]:
	var return_array: Array[CellData] = []
	var block_index = get_index_from_vector(block_id)
	
	line_number = clampi(line_number,0,2)
	var starting_point = line_number * 3
	
	return_array.append(CellData.new_cell_data(CellLocation.new_cell(starting_point, block_id), game_array[block_index][starting_point]))
	return_array.append(CellData.new_cell_data(CellLocation.new_cell(starting_point + 1, block_id), game_array[block_index][starting_point + 1]))
	return_array.append(CellData.new_cell_data(CellLocation.new_cell(starting_point + 2, block_id), game_array[block_index][starting_point + 2]))
	
	return return_array

func _get_vertical_line_in_block(line_number: int, block_id:Vector2i, game_array) -> Array[CellData]:
	var return_array: Array[CellData] = []
	var block_index = get_index_from_vector(block_id)
	
	line_number = clampi(line_number,0,2)
	var jump = 3
	
	return_array.append(CellData.new_cell_data(CellLocation.new_cell(line_number, block_id), game_array[block_index][line_number]))
	return_array.append(CellData.new_cell_data(CellLocation.new_cell(line_number + jump, block_id), game_array[block_index][line_number + jump]))
	return_array.append(CellData.new_cell_data(CellLocation.new_cell(line_number + (jump * 2), block_id), game_array[block_index][line_number + (jump * 2)]))
	
	return return_array

func _get_line_from_point(point: Vector2i, block_point: Vector2i, horizontal: bool, game_array) -> Array[CellData]:
	var block_vectors_to_check 
	
	if horizontal: block_vectors_to_check = _get_horizontal_neighbor_block_vectors(block_point)
	else: block_vectors_to_check = _get_vertical_neighbor_block_vectors(block_point)
	
	var return_array: Array[CellData] = []
	
	var point_index = get_index_from_vector(point)
	
	#print("block: " + str(block_point) + ", blocks to check: " + str(block_vectors_to_check))
	
	for block_vector in block_vectors_to_check:
		if horizontal:
			return_array.append_array(
				_get_horizontal_line_in_block(point.x, block_vector ,game_array)
			)
		else:
			return_array.append_array(
				_get_vertical_line_in_block(point.y, block_vector ,game_array)
			)
	
	return return_array

func get_instances_indexes_in_block(number: int, number_index: int, block: Array[int]) -> Array[int]:
	var index: int = 0
	var ret_array: Array[int] = []
	for cell in block:
		if number_index == index: 
			index = index + 1
			continue
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
	var points_in_block = get_instances_indexes_in_block(number, cell_location.index_identifier, game_array[get_index_from_vector(cell_location.parent_block_id)])
	for cell in points_in_block:
		return_array.append(CellLocation.new_cell(cell, cell_location.parent_block_id))
	
	#check lines
	#horizontal
	var cells_in_horizontal_line = _get_line_from_point(cell_vector, cell_location.parent_block_id, true, game_array)
	for cell in cells_in_horizontal_line:
		var block_index = get_index_from_vector(cell.cell_location.parent_block_id)
		if game_array[block_index][cell.cell_location.index_identifier] == number:
			return_array.append(cell.cell_location)
	
	#vertical
	var numbers_in_vertical_line = _get_line_from_point(cell_vector, cell_location.parent_block_id, false, game_array)
	for cell in numbers_in_vertical_line:
		var block_index = get_index_from_vector(cell.cell_location.parent_block_id)
		if game_array[block_index][cell.cell_location.index_identifier] == number:
			return_array.append(cell.cell_location)
			
	return return_array
