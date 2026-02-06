class_name Soduku_Creator extends Node

#basic standard starting point
var block_1: Array[int] = [8,6,3,7,1,9,2,5,4]
var block_2: Array[int] = [5,7,9,4,2,3,8,6,1]
var block_3: Array[int] = [2,1,4,6,8,5,3,9,7]
var block_4: Array[int] = [4,2,6,1,9,8,5,3,7]
var block_5: Array[int] = [1,8,7,6,3,5,2,9,4]
var block_6: Array[int] = [9,5,3,4,7,2,1,6,8]
var block_7: Array[int] = [9,4,5,6,8,1,3,7,2]
var block_8: Array[int] = [3,1,8,7,4,2,9,5,6]
var block_9: Array[int] = [7,2,6,5,3,9,8,4,1]
var board_array = [block_1, block_2, block_3, block_4, block_5, block_6, block_7, block_8, block_9]

func _init() -> void:
	pass

func setup_new_game() -> Array:
	randomize()
	
	#shuffle part
	var shuffle_original = [
		[0,1,2],
		[3,4,5],
		[6,7,8]
	]
	var shuffle_numbers = shuffle_original.duplicate()
	shuffle_numbers.shuffle()
	
	for r in range(4,randi_range(8,20)):
		var picked_array = shuffle_numbers.pop_back().duplicate()
		picked_array.shuffle()
		var one = picked_array.pop_back()
		var two = picked_array.pop_back()
		
		randomize()
		if randf_range(0,1.87) > randf_range(0.8,1.2):
			shift_horizontal_line(one,two)
		else:
			shift_vertical_line(one, two)
		
		shuffle_numbers = shuffle_original.duplicate()
		shuffle_numbers.shuffle()
	
	#random cells to take out
	for rcells in range(randi_range(12,22)):
		var one_cell = get_cell_location_from_global_index(randi_range(0,80))
		var other_cell = get_rotational_counterpart(one_cell)
		
		(board_array[Soduku_Solver.get_index_from_vector(one_cell.parent_block_vector)])[Soduku_Solver.get_index_from_vector(one_cell.location_vector)] = 0
		(board_array[Soduku_Solver.get_index_from_vector(other_cell.parent_block_vector)])[Soduku_Solver.get_index_from_vector(other_cell.location_vector)] = 0
	
	return board_array

func _get_rotational_counterpart_int(index: int) -> int:
	match index:
		0:
			return 2
		1:
			return 1
		2:
			return 0
	return 0

func get_rotational_counterpart(cell_selected:CellLocation) -> CellLocation:
	var new_block_vector = Vector2i(_get_rotational_counterpart_int(cell_selected.parent_block_vector.x), _get_rotational_counterpart_int(cell_selected.parent_block_vector.y))
	var new_index_vector = Vector2i(_get_rotational_counterpart_int(cell_selected.location_vector.x), _get_rotational_counterpart_int(cell_selected.location_vector.y))
	return CellLocation.new_cell(new_index_vector, new_block_vector)

func shift_horizontal_line(x_1: int, x_2: int) -> void:
	x_1 = clampi(x_1, 0, 8)
	x_2 = clampi(x_2, 0, 8)
	
	var x_1_x_locs = get_block_x(x_1)
	var x_2_x_locs = get_block_x(x_2)
	
	#var x1_numbers = []
	#var x2_numbers = []
	
	for y_board in range(0,3):
		for y_block in range(0,3):
			var block1 = board_array[Soduku_Solver.get_index_from_vector(Vector2i(x_1_x_locs.x,y_board))]
			#x1_numbers.append(block1[Soduku_Solver.get_index_from_vector(Vector2i(x_1_x_locs.y,y_block))])
			var x1_original_index = Soduku_Solver.get_index_from_vector(Vector2i(x_1_x_locs.y,y_block))
			
			var block2 = board_array[Soduku_Solver.get_index_from_vector(Vector2i(x_2_x_locs.x,y_board))]
			#x2_numbers.append(block2[Soduku_Solver.get_index_from_vector(Vector2i(x_2_x_locs.y,y_block))])
			var x2_original_index = Soduku_Solver.get_index_from_vector(Vector2i(x_2_x_locs.y,y_block))
			
			#swap
			var temp_x1 = block1[x1_original_index]
			block1[x1_original_index] = block2[x2_original_index]
			block2[x2_original_index] = temp_x1
			
			board_array[Soduku_Solver.get_index_from_vector(Vector2i(x_1_x_locs.x,y_board))] = block1
			board_array[Soduku_Solver.get_index_from_vector(Vector2i(x_2_x_locs.x,y_board))] = block2

func shift_vertical_line(y_1: int, y_2: int) -> void:
	y_1 = clampi(y_1, 0, 8)
	y_2 = clampi(y_2, 0, 8)
	
	var y_1_y_locs = get_block_x(y_1)
	var y_2_y_locs = get_block_x(y_2)
	
	#var x1_numbers = []
	#var x2_numbers = []
	
	for x_board in range(0,3):
		for x_block in range(0,3):
			var block1 = board_array[Soduku_Solver.get_index_from_vector(Vector2i(x_board, y_1_y_locs.x))]
			var y1_original_index = Soduku_Solver.get_index_from_vector(Vector2i(x_block, y_1_y_locs.y))
			
			var block2 = board_array[Soduku_Solver.get_index_from_vector(Vector2i(x_board, y_2_y_locs.x))]
			var y2_original_index = Soduku_Solver.get_index_from_vector(Vector2i(x_block, y_2_y_locs.y))
			
			#swap
			var temp_y1 = block1[y1_original_index]
			block1[y1_original_index] = block2[y2_original_index]
			block2[y2_original_index] = temp_y1
			
			board_array[Soduku_Solver.get_index_from_vector(Vector2i(x_board, y_1_y_locs.x))] = block1
			board_array[Soduku_Solver.get_index_from_vector(Vector2i(x_board, y_2_y_locs.x))] = block2

func get_block_x(x) -> Vector2i:
	#vector.x -> block x to the game board    [0,1,2 => 0] [3,4,5 => 1]
	#vector.y -> x in the block in the game board, x%3 will get that
	return Vector2i(floori(x/3),x%3)

func get_cell_location_from_global_index(global_index: int) -> CellLocation:
	var block_index = floori(global_index / 9)
	var index_id = (global_index - (9 * block_index))
	
	return CellLocation.new_cell(Soduku_Solver.get_vector_from_index(index_id),Soduku_Solver.get_vector_from_index(block_index))
