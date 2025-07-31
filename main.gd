extends Control

enum CellTypes {
	DEAD,
	ALIVE,
}

enum GridPhases {
	SETUP,
	PLAY,
	PAUSE,
}

var grid_size = Vector2i(20, 20)
var grid = []
var simulation_grid = []
var selected_cell_type: CellTypes = CellTypes.DEAD
var grid_phase: GridPhases = GridPhases.SETUP


func _ready():
	var ui_cell_count = 0
		
	for y in range(grid_size.y):
		var row = []
		for x in range(grid_size.x):
			var ui_cell = UICell.new(Vector2i(x, y))
			%Grid.add_child(ui_cell)
			ui_cell.cell_selected.connect(_on_cell_selected)
			row.append(DeadCell.new(ui_cell))
			ui_cell_count += 1
		grid.append(row)

	grid[5][5] = AliveCell.new(grid[5][5].color_rect)
	grid[6][5] = AliveCell.new(grid[6][5].color_rect)
	grid[7][5] = AliveCell.new(grid[7][5].color_rect)
		
	connect_cells(grid)


func tick():
	var temp_grid := []

	for y in range(grid_size.y):
		var row := []
		for x in range(grid_size.x):
			var new_cell = simulation_grid[y][x].tick()
			row.append(new_cell)
		temp_grid.append(row)

	connect_cells(temp_grid)
	simulation_grid = temp_grid


func connect_cells(grid: Array):
	for y in range(grid.front().size()):
		for x in range(grid.size()):
			var cell: Cell = grid[y][x]
			cell.neighbours.clear()
			
			if y > 0 and x > 0:
				cell.neighbours.append(grid[y-1][x-1])
			if y > 0:
				cell.neighbours.append(grid[y-1][x])
			if y > 0 and x < grid_size.x - 1:
				cell.neighbours.append(grid[y-1][x+1])
			if x > 0:
				cell.neighbours.append(grid[y][x-1])
			if x < grid_size.x - 1:
				cell.neighbours.append(grid[y][x+1])
			if y < grid_size.y - 1 and x > 0:
				cell.neighbours.append(grid[y+1][x-1])
			if y < grid_size.y - 1:
				cell.neighbours.append(grid[y+1][x])
			if y < grid_size.y - 1 and x < grid_size.x - 1:
				cell.neighbours.append(grid[y+1][x+1])




func _on_timer_timeout() -> void:
	tick()


func _on_dead_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		selected_cell_type = CellTypes.DEAD
		print(selected_cell_type)


func _on_alive_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		selected_cell_type = CellTypes.ALIVE
		print(selected_cell_type)


func _on_cell_selected(cell: UICell):
	if not grid_phase == GridPhases.SETUP:
		return
		
	match selected_cell_type:
		CellTypes.DEAD:
			grid[cell.grid_position.x][cell.grid_position.y] = DeadCell.new(cell)
		CellTypes.ALIVE:
			grid[cell.grid_position.x][cell.grid_position.y] = AliveCell.new(cell)


func _on_setup_pressed() -> void:
	
	grid_phase = GridPhases.SETUP


func _on_play_pressed() -> void:
	connect_cells(grid)
	simulation_grid = grid.duplicate()
	$Timer.start()
	grid_phase = GridPhases.PLAY
