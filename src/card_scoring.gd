class_name CardScoring
extends PanelContainer

@onready var card_grid: GridContainer = %CardGrid

var score: int = 0


func score_cards(cards: Array[Card.Data]) -> int:
	for card in cards:
		_score_card(Create.Card(card))
		await get_tree().create_timer(1.0).timeout
	
	return pop_result()

func _score_card(card: Card):
	card_grid.add_child(card)

	match card.data.type:
		Card.Type.MULTIPLIER:
			score *= card.data.value
		Card.Type.VALUE:
			score += card.data.value

func pop_result() -> int:
	
	var result = score
	
	score = 0

	for c in card_grid.get_children():
		c.queue_free()

	return result
