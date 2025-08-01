class_name Main
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

@export var levels: Array[Level]
@export var grid_size := Vector2i(4, 4)
var grid = []
var simulation_grid = []
var selected_level_cell: LevelCell
var grid_phase: GridPhases = GridPhases.SETUP
var tick_count: int = 0:
	set(new_val):
		tick_count = new_val
		%TickLabel.text = "Tick: " + str(tick_count) + "/100"

func _ready():
	load_level(levels[0])

func load_level(level: Level):
	grid = []
	simulation_grid = []
	grid_phase = GridPhases.SETUP
	tick_count = 0
	
	for child in %Colors.get_children():
		child.queue_free()
		
	for child in %Grid.get_children():
		child.queue_free()
	
	grid_size = level.grid_size
	
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


	for cell in level.cells:
		var ui = UICellType.new(cell)
		ui.cell_selected.connect(_on_type_cell_selected)
		%Colors.add_child(ui)

	selected_level_cell = %Colors.get_child(0).level_cell
	
	%Chat.text = level.text


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
	
	if tick_count == 100:
		check_alive_cells()
	
	
func check_alive_cells() -> bool:
	var row_count = simulation_grid.size()
	var col_count = simulation_grid[0].size()
	
	for y in range(row_count):
		for x in range(col_count):
			var cell: Cell = simulation_grid[y][x]
			if cell is AliveCell:
				return true
	return false
	

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
		
	if selected_level_cell.amount == 0:
		return
	
	var cell_type: CellTypes
	var grid_cell: Cell = grid[cell.grid_position.x][cell.grid_position.y]
	if grid_cell is DeadCell:
		cell_type = CellTypes.DEAD
	elif grid_cell is AliveCell:
		cell_type = CellTypes.ALIVE
	elif grid_cell is DestroyerCell:
		cell_type = CellTypes.DESTROYER
	elif grid_cell is ReplicatorCell:
		cell_type = CellTypes.REPLICATOR
	elif grid_cell is InfectorCell:
		cell_type = CellTypes.INFECTOR
	elif grid_cell is WallCell:
		cell_type = CellTypes.WALL
	
	if cell_type == selected_level_cell.cell_type:
		return
	
	match selected_level_cell.cell_type:
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
			
	selected_level_cell.amount -= 1

	for child in %Colors.get_children():
		if child.level_cell.cell_type == cell_type:
			child.level_cell.amount += 1
		

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
			

func _on_type_cell_selected(cell: UICellType):
	selected_level_cell = cell.level_cell
