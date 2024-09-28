class_name Utils
extends Node

static func get_index_from_probability_distribution(distribution: Array[float]) -> int:
	var sum = 0.0

	for value in distribution:
		assert(value >= 0.0)
		sum += value

	assert(is_equal_approx(sum, 1.0))

	var random_value = randf()

	var cumulative_probability = 0.0

	for i in range(distribution.size()):
		cumulative_probability += distribution[i]
		if random_value < cumulative_probability:
			return i

	return 0


static func shake(node: CanvasItem, duration: float, magnitude: float) -> Tween:
	var tween = node.create_tween()
	const shake_duration: float = 0.01
	
	var n_shakes: int = int(duration / shake_duration)
	
	for i in range(n_shakes):
		tween.tween_property(node, "position", node.position + Vector2(randf_range(-magnitude, magnitude), randf_range(-magnitude, magnitude)), shake_duration)
		tween.tween_property(node, "position", node.position, shake_duration)
	
	return tween

static func jelly_scale(node: CanvasItem, duration: float) -> Tween:
	var tween = node.create_tween()
	var target_scale = node.scale
	node.scale = Vector2.ZERO
	tween.tween_property(node, "scale", target_scale, duration).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	
	return tween


static func jiggle(node: CanvasItem, magnitude: float, n_jiggles: int = 1, original_scale: Vector2 = Vector2.ONE) -> Tween:
	var tween = node.create_tween()

	var upper_scale = node.scale + Vector2.ONE * magnitude
	var lower_scale = node.scale - Vector2.ONE * magnitude

	for n in range(n_jiggles):
		tween.tween_property(node, "scale", upper_scale, 0.05)
		tween.tween_property(node, "scale", lower_scale, 0.05)
	
	tween.tween_property(node, "scale", original_scale, 0.05)
	
	return tween
