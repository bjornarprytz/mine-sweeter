class_name Deck
extends Control

@onready var label: RichTextLabel = %Label

var cards: Array[Card.Data] = []

func add_card(card: Card.Data) -> void:
	cards.push_back(card)
	label.clear()
	label.append_text("Deck (%s)" % str(cards.size()))

func pop_cards(n: int) -> Array[Card.Data]:
	var drawn_cards: Array[Card.Data] = []

	for i in range(n):
		if cards.size() == 0:
			break
		drawn_cards.push_back(cards.pop_front())

	label.clear()
	label.append_text("Deck (%s)" % str(cards.size()))

	return drawn_cards

func shuffle() -> void:
	cards.shuffle()
