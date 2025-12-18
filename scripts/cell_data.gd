class_name CellData extends Node

var cell_location: CellLocation = CellLocation.new()
var content: int
var auto_candidates: Array[int]
var player_candidates: Array[int]

static func new_cell_data(location: CellLocation, cntn: int) -> CellData:
	var new_cell = CellData.new()
	new_cell.cell_location = location
	new_cell.content = cntn
	return new_cell
