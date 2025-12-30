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

func print_cell() -> String:
	#return "(" + str(index_identifier) + ", "  + str(parent_block_vector) + ")"
	return "{" + str(location_vector) + ", "  + str(parent_block_vector) + "}"
