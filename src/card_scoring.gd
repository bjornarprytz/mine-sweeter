class_name CardScoring
extends PanelContainer

@onready var card_container: HBoxContainer = %CardContainer
@onready var score_label: RichTextLabel = %ScoreLabel

var score: int = 0:
	set(value):
		if score == value:
			return
		score = value

func score_cards(cards: Array[Card.Data]) -> int:
	score = 0
	await _slide_in()
	for card in cards:
		await _score_card(Create.Card(card))
		await get_tree().create_timer(1.0).timeout
	
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

func _score_card(card: Card):
	card_container.add_child(card)

	await card.pop_in()

	match card.data.type:
		Card.Type.MULTIPLIER:
			score *= card.data.value
		Card.Type.VALUE:
			score += card.data.value


func pop_result() -> int:
	for card in card_container.get_children():
		card.queue_free()
	return score
