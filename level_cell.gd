class_name LevelCell
extends Resource

signal  amount_changed(int)

@export var cell_type: Main.CellTypes
@export var amount: int = 3:
	set(new_val):
		amount = new_val
		amount_changed.emit(amount)
