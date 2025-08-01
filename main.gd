extends Control

enum CellTypes {
	DEAD,
	ALIVE,
	DESTROYER,
	REPLICATOR,
	INFECTOR,
	WALL,
}

enum GridPhases {
	SETUP,
	PLAY,
	PAUSE,
}

@export var grid_size := Vector2i(4, 4)
var grid = []
var simulation_grid = []
var selected_cell_type: CellTypes = CellTypes.DEAD
var grid_phase: GridPhases = GridPhases.SETUP
var tick_count: int = 0:
	set(new_val):
		tick_count = new_val
		%TickLabel.text = "Tick: " + str(tick_count) + "/100"

func _ready():
	var ui_cell_count = 0
	%Grid.columns = grid_size.x
		
	for y in range(grid_size.y):
		var row = []
		for x in range(grid_size.x):
			var ui_cell = UICell.new(Vector2i(y, x))
			%Grid.add_child(ui_cell)
			ui_cell.cell_selected.connect(_on_cell_selected)
			row.append(DeadCell.new(ui_cell))
			ui_cell_count += 1
		grid.append(row)
		
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
	
	tick_count +=1


func connect_cells(grid: Array):
	var row_count = grid.size()
	var col_count = grid[0].size()
	for y in range(row_count):
		for x in range(col_count):
			var cell: Cell = grid[y][x]
			cell.neighbours.clear()
			
			if y > 0:
				if x > 0:
					cell.neighbours.append(grid[y-1][x-1])
				cell.neighbours.append(grid[y-1][x])
				if x < col_count - 1:
					cell.neighbours.append(grid[y-1][x+1])
			if x > 0:
				cell.neighbours.append(grid[y][x-1])
			if x < col_count - 1:
				cell.neighbours.append(grid[y][x+1])
			if y < row_count - 1:
				if x > 0:
					cell.neighbours.append(grid[y+1][x-1])
				cell.neighbours.append(grid[y+1][x])
				if x < col_count - 1:
					cell.neighbours.append(grid[y+1][x+1])



func _on_timer_timeout() -> void:
	tick()
	

func _on_cell_selected(cell: UICell):
	if not grid_phase == GridPhases.SETUP:
		return
		
	match selected_cell_type:
		CellTypes.DEAD:
			grid[cell.grid_position.x][cell.grid_position.y] = DeadCell.new(cell)
		CellTypes.ALIVE:
			grid[cell.grid_position.x][cell.grid_position.y] = AliveCell.new(cell)
		CellTypes.DESTROYER:
			grid[cell.grid_position.x][cell.grid_position.y] = DestroyerCell.new(cell)
		CellTypes.REPLICATOR:
			grid[cell.grid_position.x][cell.grid_position.y] = ReplicatorCell.new(cell)
		CellTypes.INFECTOR:
			grid[cell.grid_position.x][cell.grid_position.y] = InfectorCell.new(cell)
		CellTypes.WALL:
			grid[cell.grid_position.x][cell.grid_position.y] = WallCell.new(cell)


func _on_setup_pressed() -> void:
	if grid_phase == GridPhases.SETUP:
		return
	
	$Timer.stop()
	grid_phase = GridPhases.SETUP
	tick_count = 0
	color_grid(grid)


func _on_play_pressed() -> void:
	match grid_phase:
		GridPhases.SETUP:
			connect_cells(grid)
			simulation_grid = grid.duplicate()
			$Timer.start()
			grid_phase = GridPhases.PLAY
			tick_count = 0
		GridPhases.PLAY:
			grid_phase = GridPhases.PAUSE
			$Timer.stop()
		GridPhases.PAUSE:
			grid_phase = GridPhases.PLAY
			$Timer.start()
	

func color_grid(grid):
	for y in range(grid.size()):
		for x in range(grid.front().size()):
			grid[y][x].color_rect.color = grid[y][x].color
			

func _on_dead_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		selected_cell_type = CellTypes.DEAD


func _on_alive_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		selected_cell_type = CellTypes.ALIVE


func _on_destroyer_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		selected_cell_type = CellTypes.DESTROYER

func _on_replicator_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		selected_cell_type = CellTypes.REPLICATOR


func _on_infector_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		selected_cell_type = CellTypes.INFECTOR


func _on_wall_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		selected_cell_type = CellTypes.WALL
