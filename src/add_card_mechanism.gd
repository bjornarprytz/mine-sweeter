extends Control

var draw_count_max: int = 6

var draw_count: int = draw_count_max:
	set(value):
		draw_count = value
		label.clear()
		label.append_text("[center]%s[/center]" % str(draw_count))

@onready var label: RichTextLabel = %Label

@export var deck: Deck

func _ready() -> void:
	Events.cell_revealed.connect(_on_cell_revealed)

func _on_cell_revealed(_cell: Cell) -> void:
	draw_count -= 1

	if draw_count <= 0:
		draw_count = draw_count_max
		deck.add_card(Card.Data.good(Card.Type.VALUE))
