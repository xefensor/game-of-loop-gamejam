class_name DestroyerCell
extends Cell


func _init(_color_rect: ColorRect) -> void:
	color = Color.DARK_RED
	color_rect = _color_rect
	color_rect.color = Color.html("#c32454")


func tick():
	return self
