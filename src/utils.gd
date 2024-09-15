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
