class_name WallCell
extends Cell


func _init(_color_rect: ColorRect) -> void:
	color = Color.SADDLE_BROWN
	color_rect = _color_rect
	color_rect.color = Color.html("#9babb2")


func tick():
	return self
