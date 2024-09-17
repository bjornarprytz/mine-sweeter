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

func Card(data: Card.Data) -> Card:
	var card = card_spawner.instantiate() as Card

	card.data = data

	return card
