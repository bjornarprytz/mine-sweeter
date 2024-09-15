class_name Deck
extends Control

@onready var label: RichTextLabel = %Label

var cards: Array[Card] = []

func add_card(card: Card) -> void:
	cards.push_back(card)
	label.append_text("Deck (%s)" % str(cards.size()))

func pop_cards(n: int) -> Array[Card]:
	var drawn_cards: Array[Card] = []

	for i in range(n):
		drawn_cards.push_back(cards.pop_front())

	label.clear()
	label.append_text("Deck (%s)" % str(cards.size()))

	return drawn_cards

func shuffle() -> void:
	cards.shuffle()
