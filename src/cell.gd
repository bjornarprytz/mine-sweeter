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
	if revealed or flagged:
		return
	
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
	if is_mine:
		Events.mine_tripped.emit(self)

func declare_scored():
	var neighbors = map.get_neighbors(self)
	var safe_neighbors: Array[Cell] = []
	var flagged_neighbors: Array[Cell] = []
	for neighbor in neighbors:
		if neighbor.flagged:
			flagged_neighbors.append(neighbor)
		elif !neighbor.revealed:
			safe_neighbors.append(neighbor)
	
	if flagged_neighbors.size() == number:
		for neighbor in safe_neighbors:
			neighbor.reveal()
		Events.mines_confirmed.emit(flagged_neighbors)

func toggle_flag():
	tag.show()
	if not revealed:
		flagged = !flagged
		if flagged:
			tag.append_text("[center][color=darkgreen]F[/color][/center]")
		else:
			tag.clear()
		Events.cell_flagged.emit(self, flagged)

func denied():
	const n_shakes: int = 10
	const shake_amount: int = 5
	const shake_duration: float = 0.01
	var tween = create_tween()
	
	var original_color = modulate
	modulate = Color(.8, .2, .2) # A more intense red color
	
	for i in range(n_shakes):
		tween.tween_property(self, "position", position + Vector2(randf_range(-shake_amount, shake_amount), randf_range(-shake_amount, shake_amount)), shake_duration)
		tween.tween_property(self, "position", position, shake_duration)
	tween.tween_property(self, "modulate", original_color, .1)
	await tween.finished

func _on_button_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and !event.is_pressed():
		if event.button_index == MOUSE_BUTTON_LEFT:
			if flagged:
				denied()
			elif revealed:
				declare_scored()
			else:
				reveal()
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			toggle_flag()
