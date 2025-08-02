class_name UICell
extends ColorRect

var grid_position := Vector2i.ZERO
var mouse_on_top: bool = false

signal cell_selected(UICell)
signal delete_cell(UICell)


func _init(_grid_position: Vector2i) -> void:
	grid_position = _grid_position
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	size_flags_vertical = Control.SIZE_EXPAND_FILL
	mouse_filter = Control.MOUSE_FILTER_PASS


func _process(delta: float) -> void:
	if mouse_on_top and Input.is_action_pressed("click"):
		cell_selected.emit(self)
	if mouse_on_top and Input.is_action_pressed("right_click"):
		delete_cell.emit(self)


func _on_mouse_entered():
	mouse_on_top = true
	
	
func _on_mouse_exited():
	mouse_on_top = false
