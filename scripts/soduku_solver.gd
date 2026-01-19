class_name Soduku_Solver extends Node

func _init() -> void:
	pass

static func get_vector_from_index(index: int) -> Vector2i:
	return Vector2i(floori(index / 3),index % 3)

static func get_index_from_vector(vector: Vector2i) -> int:
	return ((vector.x * 3) + vector.y)

func check_duplicates_in_location(game_array, location: CellLocation) -> Array[CellLocation]:
	var retrn_array:Array[CellLocation] = []
	var block_index = get_index_from_vector(location.parent_block_vector)
	var number_in_question = (game_array[block_index])[get_index_from_vector(location.location_vector)]
	#print("parent block of input: " + str(location.parent_block_vector))
	
	#check block
	retrn_array.append_array(check_duplicates_in_block(game_array[block_index], location.parent_block_vector,get_index_from_vector(location.location_vector) , number_in_question))
	
	#check horizontal
	retrn_array.append_array(check_duplicate_horizontal(game_array, location, number_in_question))
	
	#check vertical
	retrn_array.append_array(check_duplicate_vertical(game_array,location, number_in_question))
	
	#add self
	if retrn_array.size() > 0:
		retrn_array.append(location)
	
	return retrn_array

func check_duplicates_in_block(block: Array[int],block_id: Vector2i, index_of_newest:int ,number:int) -> Array[CellLocation]:
	var retrn_array:Array[CellLocation] = []
	for elm in range(0,block.size()):
		if elm == index_of_newest: continue
		if number == block[elm]: retrn_array.append(CellLocation.new_cell(get_vector_from_index(elm), block_id))
	return retrn_array

#on y
func check_duplicate_horizontal(game_array, location: CellLocation, number: int) -> Array[CellLocation]:
	var retrn_array:Array[CellLocation] = []
	#print("number to compare: " + str(number))
	
	#x is the same, check y in block locations and inside each block
	for block_y in range(0,3):
		#print("blocky: " + str(block_y) + ", parent blocky: " + str(location.parent_block_vector.y))
		if block_y == location.parent_block_vector.y: continue
		
		var block_vector = Vector2i(location.parent_block_vector.x, block_y)
		var block_index = get_index_from_vector(block_vector)
		
		#print("block to inspect: " + str(block_vector))
		
		for inside_y in range(0,3):
			var element_vector = Vector2i(location.location_vector.x, inside_y)
			var element_index = get_index_from_vector(element_vector)
			
			#print("element to inspect: block: " + str(block_vector) + ", place: " + str(element_vector) + ", number: " + str((game_array[block_index])[element_index]))
			
			if (game_array[block_index])[element_index] == number:
				#print("DING")
				retrn_array.append(CellLocation.new_cell(element_vector, block_vector))
	
	return retrn_array

#on x
func check_duplicate_vertical(game_array, location: CellLocation, number: int) -> Array[CellLocation]:
	var retrn_array:Array[CellLocation] = []
	
	#y is the same, check x in block locations and inside each block
	for block_x in range(0,3):
		if block_x == location.parent_block_vector.x: continue
		
		var block_vector = Vector2i(block_x, location.parent_block_vector.y)
		var block_index = get_index_from_vector(block_vector)
		
		for inside_x in range(0,3):
			var element_vector = Vector2i(inside_x, location.location_vector.y)
			var element_index = get_index_from_vector(element_vector)
			if (game_array[block_index])[element_index] == number:
				retrn_array.append(CellLocation.new_cell(element_vector, block_vector))
	
	return retrn_array

func print_cellLocation_array(array: Array[CellLocation]) -> String:
	var ret_string = "[\n"
	for cell_location in array:
		ret_string = ret_string + cell_location.print_cell() + ",\n"
	ret_string = ret_string + "]"
	return ret_string
