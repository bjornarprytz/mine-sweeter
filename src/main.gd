extends Node2D

var grid_size = Vector2(10, 10)
var cell_size = 64
var mine_count = 15

var grid = []

@onready var cell_spawner = preload("res://cell.tscn")

func _ready():
	create_grid()
	place_mines()
	calculate_numbers()

func create_grid():
	for x in range(grid_size.x):
		grid.append([])
		for y in range(grid_size.y):
			var cell = cell_spawner.instantiate() as Cell
			cell.position = Vector2(x, y) * cell_size
			cell.coordinates = Vector2(x, y)
			add_child(cell)
			grid[x].append(cell)
			cell.cell_revealed.connect(_on_cell_revealed)

func _on_cell_revealed(cell: Cell):
	if cell.number > 0 or cell.is_mine or cell.flagged:
		return

	await get_tree().create_timer(0.1).timeout

	for dx in [-1, 0, 1]:
		for dy in [-1, 0, 1]:
			var nx = cell.coordinates.x + dx
			var ny = cell.coordinates.y + dy
			if nx >= 0 and nx < grid_size.x and ny >= 0 and ny < grid_size.y:
				var adjacent_cell = grid[nx][ny]
				if not adjacent_cell.is_mine and not adjacent_cell.revealed:
					adjacent_cell.reveal()

func place_mines():
	var mines_placed = 0
	while mines_placed < mine_count:
		var x = randi() % int(grid_size.x)
		var y = randi() % int(grid_size.y)
		if not grid[x][y].is_mine:
			grid[x][y].initialize(true, 0)
			mines_placed += 1

func calculate_numbers():
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			if grid[x][y].is_mine:
				continue
			var number = count_adjacent_mines(x, y)
			grid[x][y].initialize(false, number)

func count_adjacent_mines(x, y):
	var count = 0
	for dx in range(-1, 2):
		for dy in range(-1, 2):
			var nx = x + dx
			var ny = y + dy
			if nx >= 0 and nx < grid_size.x and ny >= 0 and ny < grid_size.y:
				if grid[nx][ny].is_mine:
					count += 1
	return count
