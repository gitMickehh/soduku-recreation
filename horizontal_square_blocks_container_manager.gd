class_name Horizontal_Boxes_Container extends HBoxContainer

var blocks: Array[Nine_Box_Manager] = []

func _ready() -> void:
	_get_blocks()

func _get_blocks() -> void:
	var children = get_children()
	for child in children:
		if child is Nine_Box_Manager:
			blocks.append(child)

func set_blocks_numbers(block_one: Array[int], block_two: Array[int], block_three: Array[int])-> void:
	blocks[0].fill_in_square(block_one)
	blocks[1].fill_in_square(block_two)
	blocks[2].fill_in_square(block_three)
