class_name DeadCell
extends Cell


func _init(_color_rect: ColorRect) -> void:
	color = Color.BLACK
	color_rect = _color_rect
	color_rect.color = color



func tick():
	var replicator_neighbours: int = 0
	var alive_neigbours: int = 0
	
	for cell in neighbours:
		if cell is ReplicatorCell:
			replicator_neighbours += 1
		if cell is AliveCell:
			alive_neigbours += 1
	
	if replicator_neighbours >= 3:
		return ReplicatorCell.new(color_rect)
	if alive_neigbours == 3:
		return AliveCell.new(color_rect)
	return self
