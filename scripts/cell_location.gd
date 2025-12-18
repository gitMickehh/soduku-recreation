class_name CellLocation extends Node

var index_identifier: int
var parent_block_id: Vector2i

static func new_cell(ind_id: int, block_id: Vector2i) -> CellLocation:
	var cell = CellLocation.new()
	cell.index_identifier = ind_id
	cell.parent_block_id = block_id
	return cell

func print_cell() -> String:
	return "(" + str(index_identifier) + ", "  + str(parent_block_id) + ")"
