class_name ExpFlower
extends Sprite2D

var target: Control
var camera: Camera2D

var velocity := 0.0

func _ready() -> void:
	camera = get_viewport().get_camera_2d()

func _process(delta: float) -> void:
	# Convert the UI element's position to world space
	var target_world_pos = get_canvas_transform().affine_inverse() * (target.position + (target.get_rect().size / 2))
	# Lerp towards the world-space position
	position = position.move_toward(target_world_pos, delta * velocity)
	velocity += delta*1000.0
	# Remove the sprite once it is close enough to the target position
	if position.distance_to(target_world_pos) < 1:
		queue_free()
