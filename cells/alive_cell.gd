class_name AliveCell
extends Cell


func _init(_color_rect: ColorRect) -> void:
	color_rect = _color_rect
	color_rect.color = Color.WHITE


func tick():
	var alive_neigbours: int = 0
	for cell in neighbours:
		if cell is not DeadCell:
			alive_neigbours += 1

	if alive_neigbours == 2 or alive_neigbours == 3:
		return self
	else:
		return DeadCell.new(color_rect)
