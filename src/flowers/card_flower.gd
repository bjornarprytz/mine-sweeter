class_name CardFlower
extends Flower

@onready var card: Card = $Card

var card_data: Card.Data

func _ready() -> void:
	card.data = card_data
