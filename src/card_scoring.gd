class_name CardScoring
extends PanelContainer

@onready var card_container: HBoxContainer = %CardContainer

var score: int = 0

func score_cards(cards: Array[Card.Data]) -> int:
	score = 0
	var additions = []
	var multipliers = []
	await _slide_in()
	for card in cards:
		await _reveal_card(Create.Card(card))
		match card.type:
			Card.Type.MULTIPLIER:
				multipliers.push_back(card)
			Card.Type.VALUE:
				additions.push_back(card)
		await get_tree().create_timer(1.0).timeout
	
	for card in additions:
		score += card.value
	for card in multipliers:
		score *= card.value

	await _slide_out()
	
	return pop_result()

func _slide_in():
	var tween = create_tween()
	tween.tween_property(self, "position:y", 620, 0.2)
	await tween.finished

func _slide_out():
	var tween = create_tween()
	tween.tween_property(self, "position:y", 725, 0.2)
	await tween.finished

func _reveal_card(card: Card):
	card_container.add_child(card)

	await card.pop_in()

func pop_result() -> int:
	for card in card_container.get_children():
		card.queue_free()
	return score
