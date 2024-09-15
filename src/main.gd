extends Node2D


@onready var map: Map = %Map
@onready var camera: Camera2D = %Camera
@onready var deck: Deck = %Deck

func _ready():
	map.create_grid()
	Events.cell_revealed.connect(_on_cell_revealed)
	
	camera.position = map.get_center_cell().position

	
func _on_cell_revealed(cell: Cell):
	if cell.number > 0 or cell.is_mine or cell.flagged:
		return

	await get_tree().create_timer(0.1).timeout

	for neighbor in map.get_neighbors(cell):
		neighbor.reveal()
