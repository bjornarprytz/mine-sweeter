class_name Deck
extends Control

@onready var label: RichTextLabel = %Label
@onready var explosion: CPUParticles2D = $Explosion

var cards: Array[Card.Data] = []

func add_card(card: Card.Data) -> void:
	cards.push_back(card)
	label.text = str(cards.size())

func pop_cards(n: int) -> Array[Card.Data]:
	var drawn_cards: Array[Card.Data] = []

	for i in range(n):
		if cards.size() == 0:
			break
		drawn_cards.push_back(cards.pop_front())

	label.text = str(cards.size())

	return drawn_cards

func shuffle() -> void:
	cards.shuffle()

func explode() -> CPUParticles2D:
	explosion.emitting = true
	explosion.reparent(get_parent())
	queue_free()
	return explosion
