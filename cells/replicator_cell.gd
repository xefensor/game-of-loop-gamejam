class_name ReplicatorCell
extends Cell


func _init(_color_rect: ColorRect) -> void:
	color = Color.ANTIQUE_WHITE
	color_rect = _color_rect
	color_rect.color = color



func tick():
	var replicator_neigbours: int = 0
	for cell in neighbours:
		if cell is DestroyerCell:
			return DeadCell.new(color_rect)
		
		if cell is ReplicatorCell:
			replicator_neigbours += 1

	if replicator_neigbours >= 4:
		return DeadCell.new(color_rect)
	else:
		return self
