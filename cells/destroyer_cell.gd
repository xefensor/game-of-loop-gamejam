class_name DestroyerCell
extends Cell


func _init(_color_rect: ColorRect) -> void:
	color = Color.html("#c32454")
	color_rect = _color_rect
	color_rect.color = color


func tick():
	return self
