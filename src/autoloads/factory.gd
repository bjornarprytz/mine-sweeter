class_name Factory
extends Node2D

# Add factory methods for common scenes here. Access through the Create singleton

@onready var cell_spawner = preload("res://cell.tscn")
@onready var card_spawner = preload("res://card.tscn")

const mine_frequency: float = .2

func Cell() -> Cell:
	var cell = cell_spawner.instantiate() as Cell

	if randf() < mine_frequency:
		cell.is_mine = true

	return cell


const good_card_values = [1, 2, 3, 4]
const good_card_values_probability_distribution = [0.50, 0.30, 0.15, 0.05]

const good_card_mul_values = [2, 3, 4, 5]
const good_card_mul_values_probability_distribution = [0.5, 0.4, 0.07, 0.03]

const bad_card_values = [-1, -2, -3, -4]
const bad_card_values_probability_distribution = [0.25, 0.5, 0.15, 0.1]

const bad_card_mul_values = [-1]
const bad_card_mul_values_probability_distribution = [1.0]

func BadCard(type: Card.Type) -> Card:
	var card = card_spawner.instantiate() as Card

	card.type = type

	match type:
		Card.Type.VALUE:
			var index = Utils.get_index_from_probability_distribution(bad_card_values_probability_distribution)
			card.value = bad_card_values[index]
		Card.Type.MULTIPLIER:
			var index = Utils.get_index_from_probability_distribution(bad_card_mul_values_probability_distribution)
			card.value = bad_card_mul_values[index]
	return card

func GoodCard(type: Card.Type) -> Card:
	var card = card_spawner.instantiate() as Card

	card.type = type

	var random_value = randf()

	var cumulative_probability = 0.0

	match type:
		Card.Type.VALUE:
			var index = Utils.get_index_from_probability_distribution(good_card_values_probability_distribution)
			card.value = good_card_values[index]
		Card.Type.MULTIPLIER:
			var index = Utils.get_index_from_probability_distribution(good_card_mul_values_probability_distribution)
			card.value = good_card_mul_values[index]
	return card
