class_name Cell
extends RefCounted


var color_rect: ColorRect
var neighbours: Array[Cell]


func _init(_color_rect: ColorRect) -> void:
	color_rect = _color_rect
	color_rect.color = Color.BLACK


func tick() -> Cell:
	return
