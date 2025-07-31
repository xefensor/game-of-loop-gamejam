class_name UICell
extends ColorRect

var grid_position := Vector2i.ZERO

signal cell_selected(UICell)

func _init(_grid_position: Vector2i) -> void:
	grid_position = _grid_position
	gui_input.connect(_on_gui_input)
	
	print(grid_position)
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	size_flags_vertical = Control.SIZE_EXPAND_FILL
	
func _on_gui_input(event: InputEvent):
	if event is InputEventMouseButton and event.pressed:
		cell_selected.emit(self)
