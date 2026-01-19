class_name Soduku_Solver extends Node

var solver_dict_template = {
	1: get_empty_cellLocation_array(),
	2: get_empty_cellLocation_array(),
	3: get_empty_cellLocation_array(),
	4: get_empty_cellLocation_array(),
	5: get_empty_cellLocation_array(),
	6: get_empty_cellLocation_array(),
	7: get_empty_cellLocation_array(),
	8: get_empty_cellLocation_array(),
	9: get_empty_cellLocation_array()
}

func get_empty_cellLocation_array()-> Array[CellLocation]:
	var ret_array: Array[CellLocation] = []
	return ret_array

func _init() -> void:
	pass

static func get_vector_from_index(index: int) -> Vector2i:
	return Vector2i(floori(index / 3),index % 3)

static func get_index_from_vector(vector: Vector2i) -> int:
	return ((vector.x * 3) + vector.y)

func check_duplicates(game_array, number: int = 0) -> Array[CellLocation]:
	var retrn_array:Array[CellLocation] = []
	var solver_dict = get_solver_dict_of_game(game_array)
	
	if number != 0:
		pass
	else:
		for n in range(1,10):
			var x_array: Array[CellLocation] = solver_dict.get(n).duplicate(false)
			x_array.sort_custom(sort_dict_array_x)
			append_array_unique(retrn_array, find_duplicates(x_array, true))
			
			var y_array: Array[CellLocation] = solver_dict[n].duplicate(false)
			y_array.sort_custom(sort_dict_array_y)
			append_array_unique(retrn_array, find_duplicates(y_array, false))
		
	return retrn_array

func get_solver_dict_of_game(game_array) -> Dictionary:
	var solver_dict = solver_dict_template.duplicate()
	#var solver_dict = {}
	
	var block_index = 0
	for block in game_array:
		var index = 0
		for n in block:
			if n != 0:
				if !solver_dict.has(n):
					solver_dict.get_or_add(n, [CellLocation.new_cell(get_vector_from_index(index), get_vector_from_index(block_index))])
				else:
					var arr = solver_dict.get(n)
					arr.append(CellLocation.new_cell(get_vector_from_index(index), get_vector_from_index(block_index)))
					solver_dict[n] = arr
			index = index + 1
		block_index = block_index + 1
	
	return solver_dict

func print_solver_dict(solver_dict_to_print) -> String:
	var ret_string = "["
	for n in range(1,10):
		ret_string = ret_string + str(n) + ": [\n\t"
		for cell_location in solver_dict_to_print[n]:
			ret_string = ret_string + cell_location.print_cell() + ", "
		ret_string = ret_string + "],\n"
	ret_string = ret_string + "]"
	return ret_string

func append_array_unique(original_array: Array[CellLocation], array_to_be_added) -> Array[CellLocation]:
	for element in array_to_be_added:
		if !original_array.has(element):
			original_array.append(element)
	return original_array

func find_duplicates(sorted_array: Array[CellLocation], on_x: bool = true) -> Array[CellLocation]:
	var retrn_array:Array[CellLocation] = []
	
	for n in range(1, sorted_array.size()):
		if on_x:
			if sorted_array[n-1].parent_block_vector == sorted_array[n].parent_block_vector:
				if !retrn_array.has(sorted_array[n]): retrn_array.append(sorted_array[n])
				continue
			
			if sorted_array[n-1].parent_block_vector.x !=  sorted_array[n].parent_block_vector.x: continue
			if sorted_array[n-1].location_vector.x !=  sorted_array[n].location_vector.x: continue
			
			if !retrn_array.has(sorted_array[n]): retrn_array.append(sorted_array[n])
		else:
			if sorted_array[n-1].parent_block_vector == sorted_array[n].parent_block_vector:
				if !retrn_array.has(sorted_array[n]): retrn_array.append(sorted_array[n])
				continue
			
			if sorted_array[n-1].parent_block_vector.y !=  sorted_array[n].parent_block_vector.y: continue
			if sorted_array[n-1].location_vector.y !=  sorted_array[n].location_vector.y: continue
			
			if !retrn_array.has(sorted_array[n]): retrn_array.append(sorted_array[n])
	return retrn_array

func sort_dict_array_x(a,b) -> bool:
	if a.location_vector.x <= b.location_vector.x:
		return true
	return false

func sort_dict_array_y(a,b) -> bool:
	if a.location_vector.y <= b.location_vector.y:
		return true
	return false

func print_cellLocation_array(array: Array[CellLocation]) -> String:
	var ret_string = "["
	ret_string = ret_string + "[\n\t"
	for cell_location in array:
		ret_string = ret_string + cell_location.print_cell() + ", "
		ret_string = ret_string + "],\n"
	ret_string = ret_string + "]"
	return ret_string
