#@tool
class_name ColorChangerTool
extends EditorScript

var default_button_stylebox:Stylebox_Group = preload("uid://b3walgbyqwln8")
const DEFAULT_HIGHLIGHTED:Stylebox_Group = preload("res://stylebox_groups/default_highlighted.tres")

const MISTAKE_BUTTON:Stylebox_Group = preload("res://stylebox_groups/mistake_button.tres")
const MISTAKE_HIGHLIGHTED:Stylebox_Group = preload("res://stylebox_groups/mistake_highlighted.tres")
const REMOVE_BUTTON:Stylebox_Group = preload("res://stylebox_groups/remove_button.tres")

const COMPLETE_BUTTON:Stylebox_Group = preload("res://stylebox_groups/complete_button.tres")
const COMPLETE_HIGHLIGHTED:Stylebox_Group = preload("res://stylebox_groups/complete_highlighted.tres")

const CANDIDATE_VIEW:Stylebox_Group = preload("res://stylebox_groups/candidate_view.tres")
const CANDIDATE_INPUT:Stylebox_Group = preload("res://stylebox_groups/candidate_input.tres")

const BUTTON_SIZE = Vector2(100,50)

var defaultColor: ColorPickerButton
var mistakeColor: ColorPickerButton
var completeColor: ColorPickerButton
var helperButtonsColor: ColorPickerButton


func _run():
	var window := Window.new()
	
	EditorInterface.popup_dialog(window, Rect2(Vector2(100,100), Vector2(720,720)))
	
	var verticalLayout = VBoxContainer.new()
	verticalLayout.set_size(Vector2(640,800))
	#verticalLayout.set_anchors_preset(Control.PRESET_CENTER)
	
	var defaultColorLabel := Label.new()
	defaultColorLabel.text = "Defaul Color"
	defaultColor = ColorPickerButton.new()
	defaultColor.custom_minimum_size = BUTTON_SIZE
	
	var mistakeColorLabel := Label.new()
	mistakeColorLabel.text = "Mistake Color"
	mistakeColor = ColorPickerButton.new()
	mistakeColor.custom_minimum_size = BUTTON_SIZE
	
	var completeColorLabel := Label.new()
	completeColorLabel.text = "Complete Color"
	completeColor = ColorPickerButton.new()
	completeColor.custom_minimum_size = BUTTON_SIZE
	
	var helperButtonsColorLabel := Label.new()
	helperButtonsColorLabel.text = "Helper Button Color"
	helperButtonsColor = ColorPickerButton.new()
	helperButtonsColor.custom_minimum_size = BUTTON_SIZE
	
	verticalLayout.add_child(defaultColorLabel)
	verticalLayout.add_child(defaultColor)
	verticalLayout.add_child(mistakeColorLabel)
	verticalLayout.add_child(mistakeColor)
	verticalLayout.add_child(completeColorLabel)
	verticalLayout.add_child(completeColor)
	verticalLayout.add_child(helperButtonsColorLabel)
	verticalLayout.add_child(helperButtonsColor)
	
	var confirmButton := Button.new()
	confirmButton.custom_minimum_size = BUTTON_SIZE
	confirmButton.text = "confirm"
	confirmButton.connect("pressed", func():
		confirm_button_pressed()
	)
	
	verticalLayout.add_child(confirmButton)
	
	window.add_child(verticalLayout)
	window.close_requested.connect(func():
		window.queue_free()
	)

func confirm_button_pressed() -> void:
	default_button_stylebox.change_color(defaultColor.color)
