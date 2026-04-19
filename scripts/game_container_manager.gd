class_name GameContainer
extends MarginContainer

var current_input: int = 0
@onready var input_lines_container: Input_Line_Manager = $Whole_Game_Container/input_lines_container

@onready var horizontal_blocks_container_1: Horizontal_Boxes_Container = $"Whole_Game_Container/Soduku_Container/horizontal_blocks_container-1"
@onready var horizontal_blocks_container_2: Horizontal_Boxes_Container = $"Whole_Game_Container/Soduku_Container/horizontal_blocks_container-2"
@onready var horizontal_blocks_container_3: Horizontal_Boxes_Container = $"Whole_Game_Container/Soduku_Container/horizontal_blocks_container-3"

var blocks: Array[Block_Manager] = []
var game_buttons: Array[Button_Logic] = []

var game_array = []
var creator: Soduku_Creator = Soduku_Creator.new()
var solver: Soduku_Solver = Soduku_Solver.new()

var horizontal_boxes_containers: Array[Horizontal_Boxes_Container] = []

signal game_started()

func _ready() -> void:
	input_lines_container.new_input_chosen.connect(_on_new_input_chosen)
	input_lines_container.toggle_candidate_view_signal.connect(_toggle_auto_candidates)
	
	horizontal_boxes_containers.append(horizontal_blocks_container_1)
	horizontal_boxes_containers.append(horizontal_blocks_container_2)
	horizontal_boxes_containers.append(horizontal_blocks_container_3)
	blocks = _get_block_objects()
	
	#start_game(creator.DIFFICULTY.MEDIUM)

func start_game(difficulty) -> void:
	game_array = creator.setup_new_game(difficulty)
	_set_numbers(game_array)
	_get_game_buttons()
	#_update_buttons_auto_candidates(game_array)
	game_started.emit()

func _on_new_input_chosen(new_input: int) -> void:
	current_input = new_input
	#print(current_input)

func _set_numbers(game_array) -> void:
	var index = 0
	var loops = 0
	for block_group in horizontal_boxes_containers:
		block_group.set_blocks_numbers(game_array[index], game_array[index+1],game_array[index+2], loops)
		block_group.connect_press(_on_board_button_pressed)
		block_group.attach_input_manager(input_lines_container)
		index = index + 3
		loops = loops + 1

func _get_block_objects() -> Array[Block_Manager]:
	var in_blocks: Array[Block_Manager] = []
	for container in horizontal_boxes_containers:
		in_blocks.append_array(container.get_blocks())
	return in_blocks

func _on_board_button_pressed(button: Button_Logic) -> void:
	
	if input_lines_container.candidate_input_mode_state:
		button.set_manual_candidate(current_input)
		return
	
	if button.number_is_equal(current_input): return
	button.set_number_text(current_input)
	game_array[Soduku_Solver.get_index_from_vector(button.cell_data.cell_location.parent_block_vector)][Soduku_Solver.get_index_from_vector(button.cell_data.cell_location.location_vector)] = current_input
		
	var dupes = solver.check_duplicates_in_location(game_array, button.cell_data.cell_location)
	print(solver.print_cellLocation_array(dupes))
	
	var dupe_numbers: Array[int] = []
	if dupes.size() > 0:
		for dupe in dupes:
			var dupe_butt:Button_Logic = blocks[solver.get_index_from_vector(dupe.parent_block_vector)].buttons[solver.get_index_from_vector(dupe.location_vector)]
			dupe_butt.set_state(dupe_butt.BUTTON_STATE.DUPLICATE)
			dupe_numbers.append(dupe_butt.get_number())
		button.set_state(button.BUTTON_STATE.DUPLICATE)
	
	after_input_check(dupe_numbers)

func _get_game_buttons() -> void:
	for block in blocks:
		for button in block.buttons:
			game_buttons.append(button)

func after_input_check(duplicate_numbers: Array[int]) -> void:
	var full_numbers = solver.get_full_numbers(game_array, duplicate_numbers)
	for f in full_numbers:
		light_up_complete_number(solver.get_number_locations(f, game_array))
	
	if input_lines_container.candidates_view_state:
		_update_buttons_auto_candidates(game_array)

func light_up_complete_number(cell_locations:Array[CellLocation]) -> void:
	for cl in cell_locations:
		var btn: Button_Logic = (blocks[solver.get_index_from_vector(cl.parent_block_vector)]).buttons[solver.get_index_from_vector(cl.location_vector)]
		btn.set_state(btn.BUTTON_STATE.COMPLETE)

func _update_buttons_auto_candidates(given_game_array) -> void:
	#this can be optimized by skipping this function when the option is not on
	for button in game_buttons:
		if button.disabled: continue
		button.update_auto_candidate_list(solver.get_non_candidates_in_location(given_game_array, button.cell_data.cell_location))

func _toggle_auto_candidates(toggle_auto_candidates_mode: bool) -> void:
	if toggle_auto_candidates_mode:
		_update_buttons_auto_candidates(game_array)
