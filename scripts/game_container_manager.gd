extends MarginContainer

var current_input: int = 0
@onready var input_lines_container: Input_Line_Manager = $Whole_Game_Container/input_lines_container

@onready var horizontal_blocks_container_1: Horizontal_Boxes_Container = $"Whole_Game_Container/Soduku_Container/horizontal_blocks_container-1"
@onready var horizontal_blocks_container_2: Horizontal_Boxes_Container = $"Whole_Game_Container/Soduku_Container/horizontal_blocks_container-2"
@onready var horizontal_blocks_container_3: Horizontal_Boxes_Container = $"Whole_Game_Container/Soduku_Container/horizontal_blocks_container-3"

#var block_1: Array[int] = [8,4,0,7,0,0,0,1,0]
#var block_2: Array[int] = [6,0,0,1,0,0,2,8,0]
#var block_3: Array[int] = [0,7,2,5,6,0,0,0,3]
#var block_4: Array[int] = [0,6,0,5,2,0,9,0,0]
#var block_5: Array[int] = [0,1,0,0,0,3,0,0,6]
#var block_6: Array[int] = [0,4,7,0,0,6,3,2,0]
#var block_7: Array[int] = [0,0,6,4,0,7,0,3,9]
#var block_8: Array[int] = [4,0,1,0,0,9,0,2,0]
#var block_9: Array[int] = [7,3,0,0,0,0,6,0,4]

var block_1: Array[int] = [1,0,0,0,0,0,0,0,0]
var block_2: Array[int] = [0,2,0,0,0,0,0,0,0]
var block_3: Array[int] = [0,0,3,0,0,0,0,0,0]
var block_4: Array[int] = [0,0,0,4,0,0,0,0,0]
var block_5: Array[int] = [0,0,0,0,5,0,0,0,0]
var block_6: Array[int] = [0,0,0,0,0,6,0,0,0]
var block_7: Array[int] = [0,0,0,0,0,0,7,0,0]
var block_8: Array[int] = [0,0,0,0,0,0,0,8,0]
var block_9: Array[int] = [0,0,0,0,0,0,0,0,9]
var blocks: Array[Block_Manager] = []

var game_array = [block_1, block_2, block_3, block_4, block_5, block_6, block_7, block_8, block_9]
var solver: Soduku_Solver = Soduku_Solver.new()

var horizontal_boxes_containers: Array[Horizontal_Boxes_Container] = []

func _ready() -> void:
	input_lines_container.new_input_chosen.connect(_on_new_input_chosen)
	
	horizontal_boxes_containers.append(horizontal_blocks_container_1)
	horizontal_boxes_containers.append(horizontal_blocks_container_2)
	horizontal_boxes_containers.append(horizontal_blocks_container_3)
	blocks = _get_block_objects()
	
	_set_numbers(game_array)

func _on_new_input_chosen(new_input: int) -> void:
	current_input = new_input
	#print(current_input)

func _set_numbers(game_array) -> void:
	var index = 0
	var loops = 0
	for block_group in horizontal_boxes_containers:
		block_group.set_blocks_numbers(game_array[index], game_array[index+1],game_array[index+2], loops)
		block_group.connect_press(_on_board_button_pressed)
		index = index + 3
		loops = loops + 1

func _get_block_objects() -> Array[Block_Manager]:
	var in_blocks: Array[Block_Manager] = []
	for container in horizontal_boxes_containers:
		in_blocks.append_array(container.get_blocks())
	return in_blocks

func _on_board_button_pressed(button: Button_Logic) -> void:
	if button.number_is_equal(current_input): return
	button.set_number_text(current_input)
	game_array[solver.get_index_from_vector(button.cell_data.cell_location.parent_block_id)][button.cell_data.cell_location.index_identifier] = current_input
	
	var dupes = solver.find_duplicates_in_game_array(current_input, CellLocation.new_cell(button.cell_data.cell_location.index_identifier, button.cell_data.cell_location.parent_block_id), game_array)
