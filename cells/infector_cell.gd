class_name InfectorCell
extends Cell


func _init(_color_rect: ColorRect) -> void:
	color = Color.MEDIUM_PURPLE
	color_rect = _color_rect
	color_rect.color = color


func tick():
	var destroyer_neigbours: int = 0
	var infector_neigbours: int = 0
	for cell in neighbours:
		if cell is DestroyerCell:
			destroyer_neigbours += 1
		if cell is InfectorCell:
			infector_neigbours += 1
			
	if destroyer_neigbours >= 1:
		return DeadCell.new(color_rect)
	if infector_neigbours >= 2:
		return DeadCell.new(color_rect)
	else:
		return self
