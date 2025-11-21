extends MarginContainer

var current_input: int = 0
@onready var input_lines_container: Input_Line_Manager = $Whole_Game_Container/input_lines_container

func _ready() -> void:
	input_lines_container.new_input_chosen.connect(_on_new_input_chosen)

func _on_new_input_chosen(new_input: int) -> void:
	current_input = new_input
	print(current_input)
