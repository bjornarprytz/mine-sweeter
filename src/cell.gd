class_name Cell
extends Node2D

var is_mine: bool = false
var number: int = 0
var revealed: bool = false
var flagged: bool = false

var coordinates: Vector2 = Vector2.ZERO

signal cell_revealed(cell: Cell)
signal cell_flagged(cell: Cell)

@onready var tag: RichTextLabel = %Tag

func reveal():
	if revealed:
		return
	revealed = true
	tag.show()
	if is_mine:
		tag.append_text("[center][color=red]X[/color][/center]")
	elif number > 0:
		tag.append_text("[center][color=blue]%s[/color][/center]" % str(number))
	cell_revealed.emit(self)

func toggle_flag():
	tag.show()
	if not revealed:
		flagged = !flagged
		if flagged:
			tag.append_text("[center][color=red]F[/color][/center]")
		else:
			tag.clear()
		cell_flagged.emit(self)

func initialize(is_mine_cell: bool, cell_number: int):
	is_mine = is_mine_cell
	number = cell_number

func _on_button_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and !event.is_pressed():
		if event.button_index == MOUSE_BUTTON_LEFT:
			reveal()
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			toggle_flag()
