class_name Soduku_Solver extends Node

var solver_dict_template = {
	1: [],
	2: [],
	3: [],
	4: [],
	5: [],
	6: [],
	7: [],
	8: [],
	9: []
}

func _init() -> void:
	pass

static func get_vector_from_index(index: int) -> Vector2i:
	return Vector2i(floori(index / 3),index % 3)

static func get_index_from_vector(vector: Vector2i) -> int:
	return ((vector.x * 3) + vector.y)

func check_duplicates(game_array) -> Array[CellLocation]:
	var retrn_array:Array[CellLocation] = []
	var solver_dict = get_solver_dict_of_game(game_array)
	
	for n in range(1,10):
		for cell_locations in solver_dict[n]:
			pass
	
	#print(print_solver_dict(solver_dict))
	return retrn_array

func get_solver_dict_of_game(game_array) -> Dictionary:
	var solver_dict = solver_dict_template.duplicate()
	
	var block_index = 0
	for block in game_array:
		var index = 0
		for n in block:
			if n != 0:
				solver_dict[n].append(CellLocation.new_cell(get_vector_from_index(index), get_vector_from_index(block_index)))
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

func sort_dict_array_x(a,b) -> bool:
	if a.x <= b.x:
		return true
	return false

func sort_dict_array_y(a,b) -> bool:
	if a.y <= b.y:
		return true
	return false
