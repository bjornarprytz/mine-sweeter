class_name MineFlower
extends Flower

@onready var explosion: CPUParticles2D = $Explosion

func _ready() -> void:
	terminus.connect(_explode)

func _explode() -> void:
	explosion.reparent(get_parent())
	explosion.emitting = true
