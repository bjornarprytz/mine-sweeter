extends Camera2D

@export var pan_speed: float = 500.0
@export var zoom_speed: float = 0.1
@export var min_zoom: float = 0.5
@export var max_zoom: float = 2.0

@export var map: Map

var current_zoom: float = 1.0
var dragging: bool = false
var last_mouse_position: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Initialize the camera
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Handle keyboard panning
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")

	# Apply faster movement if Shift is pressed
	var speed_multiplier = 2.0 if Input.is_action_pressed("shift") else 1.0
	position += input_vector * pan_speed * speed_multiplier * delta

	# Only restrict movement when there's no input
	if input_vector == Vector2.ZERO and not dragging:
		restrict_movement()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("drag"):
		dragging = true
		last_mouse_position = event.position
	elif event.is_action_released("drag"):
		dragging = false
	elif event is InputEventMouseMotion and dragging:
		# Pan the camera while dragging
		position += (last_mouse_position - event.position) / zoom
		last_mouse_position = event.position
	elif event.is_action_pressed("zoom_in"):
		# Zoom in with plus key
		zoom_camera(zoom_speed)
	elif event.is_action_pressed("zoom_out"):
		# Zoom out with minus key
		zoom_camera(-zoom_speed)

func zoom_camera(zoom_amount: float) -> void:
	current_zoom = clampf(current_zoom + zoom_amount, min_zoom, max_zoom)
	zoom = Vector2.ONE * current_zoom
	restrict_movement()

func restrict_movement() -> void:
	# Restrict movement so that the game board can't get out of view
	var camera_size = get_viewport_rect().size / zoom
	var map_center = map.get_center_cell().position

	# Check if camera is out of bounds
	var out_of_bounds = (
		position.x < 0 or
		position.x > map.bounds.size.x or
		position.y < 0 or
		position.y > map.bounds.size.y
	)

	if out_of_bounds:
		# Lerp towards map center
		var target_position = position.lerp(map_center, 0.04)
		position = target_position
