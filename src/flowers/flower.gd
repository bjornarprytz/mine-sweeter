class_name Flower
extends Node2D

var target: Control
var camera: Camera2D

var velocity := 0.0
var rotation_speed := 0.0
var target_world_pos := Vector2.ZERO

signal terminus

func _ready() -> void:
	camera = get_viewport().get_camera_2d()

func _process(delta: float) -> void:
	# Convert the UI element's position to world space
	if target != null and !target.is_queued_for_deletion():
		target_world_pos = get_canvas_transform().affine_inverse() * (target.position + (target.get_rect().size / 2))
	# Lerp towards the world-space position
	position = position.move_toward(target_world_pos, delta * velocity)
	velocity += delta * 1000.0
	rotation += delta * rotation_speed
	# Remove the sprite once it is close enough to the target position
	if position.distance_to(target_world_pos) < 1:
		terminus.emit()
		queue_free()
