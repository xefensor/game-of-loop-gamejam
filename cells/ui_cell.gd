class_name UICell
extends ColorRect

var grid_position := Vector2i.ZERO

signal cell_selected(UICell)

func _init(_grid_position: Vector2i) -> void:
	grid_position = _grid_position
	gui_input.connect(_on_gui_input)
	
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	size_flags_vertical = Control.SIZE_EXPAND_FILL
	mouse_filter = Control.MOUSE_FILTER_PASS
	
	
func _on_gui_input(event: InputEvent):
	if event.is_pressed():
		cell_selected.emit(self)
