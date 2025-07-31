extends Control


var grid_size = Vector2i(20, 20)
var grid = []


func _ready():
	var ui_cells = %Grid.get_children()
	var ui_cell_count = 0
		
	for y in range(grid_size.y):
		var row = []
		for x in range(grid_size.x):
			row.append(DeadCell.new(ui_cells[ui_cell_count]))
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
			var new_cell = grid[y][x].tick()
			row.append(new_cell)
		temp_grid.append(row)

	connect_cells(temp_grid)
	grid = temp_grid


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
