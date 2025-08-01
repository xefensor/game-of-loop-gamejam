class_name UICellType
extends ColorRect

signal cell_selected(UICellType)

var level_cell: LevelCell


func _init(_level_cell: LevelCell) -> void:
	level_cell = _level_cell
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	size_flags_vertical = Control.SIZE_EXPAND_FILL
	gui_input.connect(_on_gui_input)
	
	match level_cell.cell_type:
		Main.CellTypes.DEAD:
			color = Color.BLACK
		Main.CellTypes.ALIVE:
			color = Color.WHITE
		Main.CellTypes.DESTROYER:
			color = Color.DARK_RED
		Main.CellTypes.REPLICATOR:
			color = Color.LIGHT_YELLOW
		Main.CellTypes.INFECTOR:
			color = Color.MEDIUM_PURPLE
		Main.CellTypes.WALL:
			color = Color.SADDLE_BROWN

	
func _on_gui_input(event: InputEvent):
	if event is InputEventMouseButton and event.pressed:
		cell_selected.emit(self)
