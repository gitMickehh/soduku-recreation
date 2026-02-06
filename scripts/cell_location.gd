class_name CellLocation extends Node

#var index_identifier: int
var location_vector: Vector2i
var parent_block_vector: Vector2i

#static func new_cell(ind_id: int, block_vector: Vector2i) -> CellLocation:
static func new_cell(ind_vector: Vector2i, block_vector: Vector2i) -> CellLocation:
	var cell = CellLocation.new()
	#cell.index_identifier = ind_id
	cell.location_vector = ind_vector
	cell.parent_block_vector = block_vector
	return cell

static func new_cell_indexes(index_self: int, index_parent: int) -> CellLocation:
	var cell = CellLocation.new()
	cell.location_vector = Soduku_Solver.get_vector_from_index(index_self)
	cell.parent_block_vector = Soduku_Solver.get_vector_from_index(index_parent)
	return cell


func print_cell() -> String:
	#return "(" + str(index_identifier) + ", "  + str(parent_block_vector) + ")"
	return "{block: " + str(parent_block_vector) + ", location: " + str(location_vector) + "}"
