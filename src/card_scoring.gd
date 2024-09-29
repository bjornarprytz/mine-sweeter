class_name CardScoring
extends PanelContainer
const SFX_REVEAL_CARD = preload("res://assets/audio/flipcard.wav")

@onready var audio: AudioStreamPlayer = $Audio

@onready var card_container: HBoxContainer = %CardContainer

func score_cards(cards: Array[Card.Data]) -> int:
	var score = 0
	var additions = []
	var multipliers = []
	for card in cards:
		await _reveal_card(Create.Card(card))
		match card.type:
			Card.Type.MULTIPLIER:
				multipliers.push_back(card)
			Card.Type.VALUE:
				additions.push_back(card)
		await get_tree().create_timer(.69).timeout
	
	for card in additions:
		score += card.value
	for card in multipliers:
		score *= card.value
	
	return score

func slide_in():
	var tween = create_tween()
	tween.tween_property(self, "position:y", 620, 0.2)
	await tween.finished

func slide_out():
	var tween = create_tween()
	tween.tween_property(self, "position:y", 825, 0.3)
	
	await tween.finished
	
	for card in card_container.get_children():
		card.queue_free()

func _reveal_card(card: Card):
	card_container.add_child(card)

	audio.stream = SFX_REVEAL_CARD
	audio.pitch_scale = .69 + randf_range(-0.1, 0.1)
	audio.play()

	await card.pop_in()
