class_name Cell
extends Node2D

const size: int = 64

enum Type {
	EMPTY,
	MINE,
}

enum State {
	## The cell is closed
	HIDDEN,
	## The cell is open
	REVEALED,
	## The player has flagged this cell as a mine
	FLAGGED,
	## It and all surrounding mines are scored
	SCORED
}

enum Hint {
	NONE,
	## All neighbour mines are flagged, presumably
	SOLVABLE,
	## All neighbour mines have been identified, and can be scored
	SCORABLE
}

var is_flagged: bool:
	get:
		return state == State.FLAGGED
	set(value):
		state = State.FLAGGED if value else State.HIDDEN

var is_revealed: bool:
	get:
		return state == State.REVEALED
	set(value):
		state = State.REVEALED if value else State.HIDDEN

var is_scored: bool:
	get:
		return state == State.SCORED
	set(value):
		state = State.SCORED if value else State.REVEALED

var is_hidden: bool:
	get:
		return state == State.HIDDEN
	set(value):
		state = State.HIDDEN if value else State.REVEALED

var is_mine: bool:
	get:
		return type == Type.MINE
	set(value):
		type = Type.MINE if value else Type.EMPTY

var is_scorable: bool:
	get:
		return hint == Hint.SCORABLE

var is_solved: bool:
	get:
		return hint == Hint.SOLVABLE

var type: Type = Type.EMPTY
var state: State = State.HIDDEN
var hint: Hint = Hint.NONE:
	set(value):
		if value == hint:
			return
		
		hint = value
		_set_ready_to_score(false)
		_set_ready_to_solve(false)

		match hint:
			Hint.NONE:
				pass
			Hint.SCORABLE:
				_set_ready_to_score(true)
			Hint.SOLVABLE:
				_set_ready_to_solve(true)

var number: int = 0
var map: Map

var coordinates: Vector2 = Vector2.ZERO

@onready var button: Button = $Button
@onready var tag: RichTextLabel = %Tag
@onready var check: Sprite2D = %Check
@onready var solve: Sprite2D = %Solve

func _ready() -> void:
	Events.cell_flagged.connect(_on_cell_flagged_changed)
	Events.cell_unflagged.connect(_on_cell_flagged_changed)

func _on_cell_flagged_changed(cell: Cell) -> void:
	if !_is_neighbour(cell):
		return
	_update_hint()


func reveal(force: bool = false):
	if is_revealed:
		return
	
	if is_flagged and !force:
		return
	
	if !Game.first_cell_revealed:
		Game.first_cell_revealed = true
		Events.tutorial_reveal_first_cell.emit()
		if type == Type.MINE:
			type = Type.EMPTY

	state = State.REVEALED

	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.05)
	tween.tween_property(self, "scale", Vector2(0.8, 0.8), 0.05)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.05)
	await tween.finished

	var neighbors = map.get_neighbors(self)
	number = 0
	for neighbor in neighbors:
		if neighbor.type == Type.MINE:
			number += 1

	tag.show()
	match type:
		Type.MINE:
			button.modulate = Color(1, 0.5, 0.5) # Light red for mines
			tag.append_text("[center][color=red]X[/color][/center]")
		Type.EMPTY:
			if number > 0:
				var hue = (number - 1) / 8.0 + 0.6 # Shift the color wheel so 1 is blue
				var saturation = 0.7 # Moderate saturation for visibility
				var value = 0.9 # High value for brightness
				button.modulate = Color.from_hsv(fmod(hue, 1.0), saturation, value)
				tag.append_text("[center][color=blue]%s[/color][/center]" % str(number))
			else:
				button.modulate = Color(0.7, 0.7, 0.7) # Darkened color for empty cells (0)

	_update_hint()

	Events.cell_revealed.emit(self)
	if type == Type.MINE:
		Events.mine_tripped.emit(self)

func _declare_scored():
	var correct_flags: Array[Cell] = []
	var errors: Array[Cell] = []
	var neighbors = map.get_neighbors(self)
	for neighbor in neighbors:
		if !neighbor.is_flagged:
			continue

		if neighbor.is_mine:
			correct_flags.append(neighbor)
		else:
			errors.append(neighbor)
	
	if errors.is_empty():
		Events.mines_confirmed.emit(correct_flags)
		for neighbor in correct_flags:
			neighbor.is_scored = true
	else:
		for cell in errors:
			cell.is_flagged = false
			cell.reveal()

func _update_hint():
	if is_hidden or number == 0 or is_mine:
		return
	
	var neighbors = map.get_neighbors(self)
	var n_neigbour_flags = 0
	var n_neigbour_mines = 0
	var n_neigbour_hidden = 0
	for neighbor in neighbors:
		if neighbor.is_flagged:
			n_neigbour_flags += 1
		elif neighbor.is_revealed and neighbor.is_mine:
			n_neigbour_mines += 1
		elif neighbor.is_hidden:
			n_neigbour_hidden += 1
	
	var mines_match_number = (n_neigbour_flags + n_neigbour_mines == number)

	if n_neigbour_hidden == 0 and (n_neigbour_flags > 0) and mines_match_number:
		hint = Hint.SCORABLE
	elif n_neigbour_hidden > 0 and mines_match_number:
		hint = Hint.SOLVABLE
	else:
		hint = Hint.NONE

func _set_ready_to_solve(yes: bool):
	if !yes:
		solve.hide()
		return
	solve.show()
	var tween = create_tween()
	var target_scale = solve.scale
	solve.scale = Vector2.ZERO
	tween.tween_property(solve, "scale", target_scale, 0.5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	await tween.finished
	
func _set_ready_to_score(yes: bool):
	if !yes:
		check.hide()
		return
	check.show()
	var tween = create_tween()
	var target_scale = check.scale
	check.scale = Vector2.ZERO
	tween.tween_property(check, "scale", target_scale, 0.5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	await tween.finished

func _reveal_neighbors():
	var neighbors = map.get_neighbors(self)
	for neighbor in neighbors:
		if !neighbor.is_flagged:
			neighbor.reveal()

func toggle_flag():
	tag.show()
	match state:
		State.HIDDEN:
			state = State.FLAGGED
			tag.append_text("[center][color=darkgreen]F[/color][/center]")
			Events.cell_flagged.emit(self)
		State.FLAGGED:
			state = State.HIDDEN
			tag.clear()
			Events.cell_unflagged.emit(self)
		_:
			pass

func denied():
	const n_shakes: int = 10
	const shake_amount: int = 5
	const shake_duration: float = 0.01
	var tween = create_tween()
	
	var original_color = button.modulate
	button.modulate = Color(.8, .2, .2) # A more intense red color
	
	for i in range(n_shakes):
		tween.tween_property(self, "position", position + Vector2(randf_range(-shake_amount, shake_amount), randf_range(-shake_amount, shake_amount)), shake_duration)
		tween.tween_property(self, "position", position, shake_duration)
	tween.tween_property(button, "modulate", original_color, .1)
	await tween.finished

func _on_button_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and !event.is_pressed():
		if event.button_index == MOUSE_BUTTON_LEFT:
			match state:
				State.FLAGGED:
					denied()
				State.REVEALED:
					match [is_mine, hint]:
						[false, Hint.SOLVABLE]:
							_reveal_neighbors()
						[false, Hint.SCORABLE]:
							_declare_scored()
						_:
							pass
				State.SCORED:
					pass
				State.HIDDEN:
					reveal()
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			toggle_flag()

func _is_neighbour(other: Cell) -> bool:
	# Check if the other cell is a neighbor
	var dx = abs(self.coordinates.x - other.coordinates.x)
	var dy = abs(self.coordinates.y - other.coordinates.y)
	
	# A cell is a neighbor if it's adjacent horizontally, vertically, or diagonally. dy and dx can't both be 0
	return dx <= 1 and dy <= 1 and (dx != 0 or dy != 0)
