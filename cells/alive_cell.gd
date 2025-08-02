class_name AliveCell
extends Cell


func _init(_color_rect: ColorRect) -> void:
	color = Color.WHITE
	color_rect = _color_rect
	color_rect.color = color


func tick():
	var destroyer_neighbours: int = 0
	var infector_neigbours: int = 0
	var alive_neigbours: int = 0
	#var replicator_neigbours: int = 0
	
	for cell in neighbours:
		if cell is DestroyerCell:
			destroyer_neighbours += 1
		if cell is InfectorCell:
			infector_neigbours += 1
		#if cell is ReplicatorCell:
		#	replicator_neigbours +=1
		if cell is AliveCell:
			alive_neigbours += 1
	
	if destroyer_neighbours >= 1:
		return DeadCell.new(color_rect)
	if infector_neigbours >= 1:
		return InfectorCell.new(color_rect)
	#if replicator_neigbours >= 3:
	#	return ReplicatorCell.new(color_rect)
	if alive_neigbours == 2 or alive_neigbours == 3:
		return self
	return DeadCell.new(color_rect)
