class_name Map
extends Node2D

var grid_size = Vector2(64, 64)
var bounds = Rect2(0, 0, 0, 0)

var grid = []

func create_grid():
	for x in range(grid_size.x):
		grid.append([])
		for y in range(grid_size.y):
			var cell = Create.Cell()
			cell.position = Vector2(x, y) * Cell.size
			cell.coordinates = Vector2(x, y)
			cell.map = self
			cell.name = "Cell(%s,%s)" % [x, y]
			add_child(cell)
			grid[x].append(cell)

	bounds = Rect2(0, 0, grid_size.x * Cell.size, grid_size.y * Cell.size)

func get_center_cell() -> Cell:
	return get_cell(grid_size.x / 2, grid_size.y / 2)

func get_cell(x, y) -> Cell:
	if x >= 0 and x < grid_size.x and y >= 0 and y < grid_size.y:
		return grid[x][y]
	return null

func get_neighbors(cell: Cell) -> Array[Cell]:
	var neighbors: Array[Cell] = []
	for dx in [-1, 0, 1]:
		for dy in [-1, 0, 1]:
			if dx == 0 and dy == 0:
				continue
			var nx = cell.coordinates.x + dx
			var ny = cell.coordinates.y + dy
			var neighbor = get_cell(nx, ny)
			if neighbor:
				neighbors.append(neighbor)
	return neighbors
