class_name CardScoring
extends PanelContainer

@onready var card_container: HBoxContainer = %CardContainer
@onready var score_label: RichTextLabel = %ScoreLabel
@onready var result_container: CenterContainer = %ResultContainer

var score: int = 0:
	set(value):
		if score == value:
			return
		score = value
		_update_score_label()

func _update_score_label() -> void:
	result_container.show()
	score_label.clear()
	score_label.append_text("[center]%d" % score)

func score_cards(cards: Array[Card.Data]) -> int:
	for card in cards:
		await _score_card(Create.Card(card))
		await get_tree().create_timer(1.0).timeout
	
	return pop_result()

func _score_card(card: Card):
	var original_scale = card.scale
	card.scale = Vector2.ZERO
	card_container.add_child(card)

	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(card, "scale", original_scale, .5)
	await tween.finished

	match card.data.type:
		Card.Type.MULTIPLIER:
			score *= card.data.value
		Card.Type.VALUE:
			score += card.data.value


func pop_result() -> int:
	var result = score
	score = 0
	for card in card_container.get_children():
		card.queue_free()
	return result
