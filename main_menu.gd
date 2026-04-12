extends Control

@onready var easy_button: Button = $"difficulty-buttons-container/easy"
@onready var med_button: Button = $"difficulty-buttons-container/med"
@onready var hard_button: Button = $"difficulty-buttons-container/hard"
@onready var difficulty_buttons_container: VBoxContainer = $"difficulty-buttons-container"
@onready var game_container: MarginContainer = $"../Game_Container"

func _ready() -> void:
	var creator = Soduku_Creator.new()
	easy_button.connect("pressed", func():
		_open_game(creator.DIFFICULTY.EASY)
	)
	
	med_button.connect("pressed", func():
		_open_game(creator.DIFFICULTY.MEDIUM)
	)
	
	hard_button.connect("pressed", func():
		_open_game(creator.DIFFICULTY.HARD)
	)

func _open_game(difficulty) -> void:
	game_container.visible = true
	game_container.start_game(difficulty)
	self.visible = false
