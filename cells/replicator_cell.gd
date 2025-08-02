class_name ReplicatorCell
extends Cell


func _init(_color_rect: ColorRect) -> void:
	color = Color.html("#f9c22b")
	color_rect = _color_rect
	color_rect.color = color


func tick():
	var destroyer_neighbours: int = 0
	var infector_neigbours: int = 0
	var replicator_neigbours: int = 0
	
	for cell in neighbours:
		if cell is DestroyerCell:
			destroyer_neighbours += 1
		if cell is InfectorCell:
			infector_neigbours += 1
		if cell is ReplicatorCell:
			replicator_neigbours += 1
		
	if destroyer_neighbours >= 1:
		return DeadCell.new(color_rect)
	if infector_neigbours >= 1:
		return InfectorCell.new(color_rect)
	if replicator_neigbours >= 4:
		return DeadCell.new(color_rect)
	return self
