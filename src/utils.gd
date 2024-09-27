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


static func shake(node: Node2D, duration: float, magnitude: float):
	var tween = node.create_tween()
	const shake_duration: float = 0.01
	
	var n_shakes: int = int(duration / shake_duration)
	
	for i in range(n_shakes):
		tween.tween_property(node, "position", node.position + Vector2(randf_range(-magnitude, magnitude), randf_range(-magnitude, magnitude)), shake_duration)
		tween.tween_property(node, "position", node.position, shake_duration)
	
	await tween.finished
