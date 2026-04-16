@icon("res://art/editor/icon_stylebox_group.png")
class_name Stylebox_Group
extends Resource

@export var normal_stylebox: StyleBox
@export var hover_stylebox: StyleBox
@export var disabled_stylebox: StyleBox

@export var color: Color

func apply_color() -> void:
	_change_color(color)

func _change_color(color: Color) -> void:
	normal_stylebox.modulate_color = color
	hover_stylebox.modulate_color = color
	disabled_stylebox.modulate_color = color
