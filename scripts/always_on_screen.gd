class_name OptionsScreen
extends Control

@onready var opening_screen: VBoxContainer = $"opening-screen"
@onready var confirm_button: Button = $"opening-screen/confirm_button"
@onready var always_on_screen: Control = $"always-on-screen"
@onready var options_button: Button = $"always-on-screen/options-button"
@onready var options_menu: VBoxContainer = $"always-on-screen/options-menu"
@onready var options_menu_color_holder: ColorRect = $"always-on-screen/options-menu-color-holder"
@onready var timer_label: Label = $"always-on-screen/timer-label"

@onready var restart_button: Button = $"always-on-screen/options-menu/restart-button"
@onready var check_puzzle_button: Button = $"always-on-screen/options-menu/check-puzzle-button"
@onready var timer_on_button: Button = $"always-on-screen/options-menu/timerOn-button"

@onready var main_menu: Control = $"../main-menu"
@onready var game_container: GameContainer = $"../Game_Container"

var game_is_on := false
var timer_is_on := false
var timer_started := false
var timer_in_seconds :float = 0

var options_opened := false

signal restart_puzzle_signal()
signal check_puzzle_signal()

func _ready() -> void:
	confirm_button.connect("pressed", _confirm_opening_message_button_pressed)
	options_button.connect("pressed", _options_button_pressed)
	
	restart_button.connect("pressed", _restart_button_pressed)
	check_puzzle_button.connect("pressed", _check_puzzle_button_pressed)
	timer_on_button.connect("pressed", _timer_on_button_pressed)
	
	game_container.connect_options_screen(self)
	game_container.game_started.connect(_on_game_started)
	
	_check_buttons_availability()
	_opening_function()

func _process(delta: float) -> void:
	_process_timer(delta)
	if timer_is_on:
		_update_timer_text()

func _opening_function() -> void:
	self.visible = true
	opening_screen.visible = true
	always_on_screen.visible = false
	main_menu.visible = false
	game_container.visible = false

func _on_game_started() -> void:
	game_is_on = true
	_start_timer()
	_check_buttons_availability()

func _start_timer() -> void:
	timer_started = true

func _process_timer(delta: float) -> void:
	if timer_started:
		timer_in_seconds += delta

func _confirm_opening_message_button_pressed() -> void:
	opening_screen.visible = false
	always_on_screen.visible = true
	main_menu.visible = true
	options_menu.visible = false
	options_menu_color_holder.visible = false
	timer_label.visible = false

func _options_button_pressed() -> void:
	if options_opened:
		_close_options_menu()
	else:
		_open_options_menu()

func _close_options_menu():
	options_menu_color_holder.visible = false
	options_menu.visible = false
	options_opened = false

func _open_options_menu():
	options_menu_color_holder.visible = true
	options_menu.visible = true
	options_opened = true

func _check_buttons_availability() -> void:
	restart_button.disabled = not game_is_on
	check_puzzle_button.disabled = not game_is_on
	timer_on_button.disabled = not game_is_on
	
	if timer_is_on:
		timer_on_button.text = "Timer Off"
	else:
		timer_on_button.text = "Timer On"

func _restart_button_pressed() -> void:
	restart_puzzle_signal.emit()
	_close_options_menu()

func _check_puzzle_button_pressed() -> void:
	check_puzzle_signal.emit()
	_close_options_menu()

func _timer_on_button_pressed() -> void:
	if timer_is_on:
		timer_label.visible = false
		timer_is_on = false
	else:
		timer_label.visible = true
		timer_is_on = true
	
	_check_buttons_availability()

func _update_timer_text() -> void:
	var timer_minutes = floori(timer_in_seconds / 60)
	var timer_seconds = floori(timer_in_seconds - (timer_minutes * 60))
	timer_label.text =  str(timer_minutes) + ":" + str(timer_seconds)
