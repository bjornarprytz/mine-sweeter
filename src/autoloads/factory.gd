class_name Factory
extends Node2D

# Add factory methods for common scenes here. Access through the Create singleton

@onready var cell_spawner = preload("res://cell.tscn")
@onready var card_spawner = preload("res://card.tscn")
@onready var exp_flower_spawner = preload("res://flowers/exp_flower.tscn")
@onready var card_flower_spawner = preload("res://flowers/card_flower.tscn")
@onready var mine_flower_spawner = preload("res://flowers/mine_flower.tscn")
@onready var score_flower_spawner = preload("res://flowers/score_flower.tscn")

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

func ExpFlower(origin: Vector2, target: Control) -> Flower:
	var exp_flower = exp_flower_spawner.instantiate() as Flower

	exp_flower.position = origin
	exp_flower.target = target
	exp_flower.modulate = Color(randf(), randf(), randf())
	exp_flower.rotation_speed = randf() * 360

	return exp_flower

func CardFlower(origin: Vector2, target: Control, card_data: Card.Data) -> CardFlower:
	var card_flower = card_flower_spawner.instantiate() as CardFlower
	card_flower.position = origin
	card_flower.card_data = card_data
	card_flower.target = target
	return card_flower


func MineFlower(origin: Vector2, target: Control) -> MineFlower:
	var mine_flower = mine_flower_spawner.instantiate() as Flower

	mine_flower.position = origin
	mine_flower.target = target
	mine_flower.modulate = Color.RED * randf_range(.5, 1)
	mine_flower.modulate.a = 1
	mine_flower.rotation_speed = randf() * 360

	return mine_flower


func ScoreFlower(origin: Vector2, target: Control) -> Flower:
	var score_flower = score_flower_spawner.instantiate() as Flower

	score_flower.position = origin
	score_flower.target = target
	score_flower.modulate = Color.GREEN * randf_range(.5, 1)
	score_flower.modulate.a = 1
	score_flower.rotation_speed = randf() * 360

	return score_flower
