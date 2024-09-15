class_name Cell
extends Node2D

const size: int = 64

var is_mine: bool = false
var number: int = 0
var revealed: bool = false
var flagged: bool = false

var map: Map

var coordinates: Vector2 = Vector2.ZERO

@onready var button: Button = $Button
@onready var tag: RichTextLabel = %Tag

func reveal():
	if revealed:
		return
	if flagged:
		toggle_flag()
	
	if !Game.first_cell_revealed:
		Game.first_cell_revealed = true
		Events.tutorial_reveal_first_cell.emit()
		if is_mine:
			is_mine = false

	revealed = true

	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.05)
	tween.tween_property(self, "scale", Vector2(0.8, 0.8), 0.05)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.05)
	await tween.finished

	var neighbors = map.get_neighbors(self)
	number = 0
	for neighbor in neighbors:
		if neighbor.is_mine:
			number += 1

	if is_mine:
		modulate = Color(1, 0.5, 0.5) # Light red for mines
	elif number > 0:
		var hue = (number - 1) / 8.0 + 0.6 # Shift the color wheel so 1 is blue
		var saturation = 0.7 # Moderate saturation for visibility
		var value = 0.9 # High value for brightness
		modulate = Color.from_hsv(fmod(hue, 1.0), saturation, value)
	else:
		modulate = Color(0.7, 0.7, 0.7) # Darkened color for empty cells (0)

	tag.show()
	if is_mine:
		tag.append_text("[center][color=red]X[/color][/center]")
	elif number > 0:
		tag.append_text("[center][color=blue]%s[/color][/center]" % str(number))
	Events.cell_revealed.emit(self)

func toggle_flag():
	tag.show()
	if not revealed:
		flagged = !flagged
		if flagged:
			tag.append_text("[center][color=darkgreen]F[/color][/center]")
		else:
			tag.clear()
		Events.cell_flagged.emit(self, flagged)

func _on_button_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and !event.is_pressed():
		if event.button_index == MOUSE_BUTTON_LEFT:
			if revealed:
				var neighbors = map.get_neighbors(self)
				var safe_neighbors: Array[Cell] = []
				var n_flagged_neighbors = 0
				for neighbor in neighbors:
					if neighbor.flagged:
						n_flagged_neighbors += 1
					elif !neighbor.revealed:
						safe_neighbors.append(neighbor)
				if n_flagged_neighbors == number:
					for neighbor in safe_neighbors:
						neighbor.reveal()
			reveal()
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			toggle_flag()
