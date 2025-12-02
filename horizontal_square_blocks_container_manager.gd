class_name Horizontal_Boxes_Container extends HBoxContainer

var blocks: Array[Block_Manager] = []

func _ready() -> void:
	_get_blocks()

func _get_blocks() -> void:
	var children = get_children()
	for child in children:
		if child is Block_Manager:
			blocks.append(child)

func set_blocks_numbers(block_one: Array[int], block_two: Array[int], block_three: Array[int], board_x: int)-> void:
	blocks[0].fill_in_square(block_one, Vector2i(board_x, 0))
	blocks[1].fill_in_square(block_two, Vector2i(board_x, 1))
	blocks[2].fill_in_square(block_three, Vector2i(board_x, 2))

func connect_press(function_to_connect: Callable) -> void:
	blocks[0].connect_press(function_to_connect)
	blocks[1].connect_press(function_to_connect)
	blocks[2].connect_press(function_to_connect)
