class_name UICellType
extends ColorRect

signal cell_selected(UICellType)

var level_cell: LevelCell
var label: Label


func _init(_level_cell: LevelCell) -> void:
	level_cell = _level_cell
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	size_flags_vertical = Control.SIZE_EXPAND_FILL
	gui_input.connect(_on_gui_input)
	
	match level_cell.cell_type:
		Main.CellTypes.DEAD:
			color = Color.html("#2e222f")
		Main.CellTypes.ALIVE:
			color = Color.WHITE
		Main.CellTypes.DESTROYER:
			color =  Color.html("#c32454")
		Main.CellTypes.REPLICATOR:
			color =  Color.html("#f9c22b")
		Main.CellTypes.INFECTOR:
			color = Color.html("#a884f3")
		Main.CellTypes.WALL:
			color = Color.html("#9babb2")
			
	label = Label.new()
	label.set_anchors_preset(Control.PRESET_HCENTER_WIDE)
	var label_settings = LabelSettings.new()
	label_settings.font_color = Color.html("#2e222f")
	label_settings.font = preload("res://font.tres")
	label_settings.font_size = 20
	label.label_settings = label_settings
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	add_child(label)
	
	level_cell.amount_changed.connect(update_label)
	
	update_label(level_cell.amount)

	
func _on_gui_input(event: InputEvent):
	if event is InputEventMouseButton and event.pressed:
		cell_selected.emit(self)


func update_label(amount: int):
	label.text = str(amount)
